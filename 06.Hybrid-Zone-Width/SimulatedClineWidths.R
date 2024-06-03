---
  title: "RedFox_HZAR_Simulatedmodels_DispTest"
output: html_document
---
  
library('hzar')

setwd("C:/Users/Sophie/Desktop/HZAR/SimulatedClineWidths")

mtDNA <- read.table("mtDNA-summary-nocotton.txt", header=T, stringsAsFactors=F) 

setwd("C:/Users/Sophie/Desktop/HZAR/")

str(mtDNA)

###Modeled as mtDNA

mydata <- hzar.doMolecularData1DPops(
  distance=mtDNA$dists,
  pObs=mtDNA$means,
  nEff=mtDNA$counts,
  siteID=mtDNA$LocIDs)

clineModel_none <- hzar.makeCline1DFreq(data=mydata,tails="none")
clineModel_none <- hzar.model.addCenterRange(clineModel_none, 0,1)
clineModel_none <- hzar.model.addMaxWidth(meta.model=clineModel_none,maxValue=1)

clineModel_right <- hzar.makeCline1DFreq(data=mydata,tails="right")
clineModel_right<- hzar.model.addCenterRange(clineModel_right, 0,1)
clineModel_right <- hzar.model.addMaxWidth(meta.model=clineModel_right,maxValue=1)

clineModel_left <- hzar.makeCline1DFreq(data=mydata,tails="left")
clineModel_left <- hzar.model.addCenterRange(clineModel_left, 0,1)
clineModel_left <- hzar.model.addMaxWidth(meta.model=clineModel_left,maxValue=1)

clineModel_both <- hzar.makeCline1DFreq(data=mydata,tails="both")
clineModel_both <- hzar.model.addCenterRange(clineModel_both, 0,1)
clineModel_both <- hzar.model.addMaxWidth(meta.model=clineModel_both,maxValue=1)

clineModel_mirror <- hzar.makeCline1DFreq(data=mydata,tails="mirror")
clineModel_mirror <- hzar.model.addCenterRange(clineModel_both, 0,1)
clineModel_mirror <- hzar.model.addMaxWidth(meta.model=clineModel_mirror,maxValue=1)



#Set initial pMin
0 -> hzar.meta.init(clineModel_none)$pMin
#Set initial pMax
1 -> hzar.meta.init(clineModel_none)$pMax

#Set initial pMin
0 -> hzar.meta.init(clineModel_right)$pMin
#Set initial pMax
1 -> hzar.meta.init(clineModel_right)$pMax

#Set initial pMin
0 -> hzar.meta.init(clineModel_left)$pMin
#Set initial pMax
1 -> hzar.meta.init(clineModel_left)$pMax

#Set initial pMin
0 -> hzar.meta.init(clineModel_both)$pMin
#Set initial pMax
1 -> hzar.meta.init(clineModel_both)$pMax

#Set initial pMin
0 -> hzar.meta.init(clineModel_mirror)$pMin
#Set initial pMax
1 -> hzar.meta.init(clineModel_mirror)$pMax



hzar.meta.fix(clineModel_none)$pMin <- TRUE
hzar.meta.fix(clineModel_none)$pMax <- TRUE

hzar.meta.fix(clineModel_right)$pMin <- TRUE
hzar.meta.fix(clineModel_right)$pMax <- TRUE

hzar.meta.fix(clineModel_left)$pMin <- TRUE
hzar.meta.fix(clineModel_left)$pMax <- TRUE

hzar.meta.fix(clineModel_both)$pMin <- TRUE
hzar.meta.fix(clineModel_both)$pMax <- TRUE

hzar.meta.fix(clineModel_mirror)$pMin <- TRUE
hzar.meta.fix(clineModel_mirror)$pMax <- TRUE


fitRequest_none <- hzar.first.fitRequest.old.ML(model=clineModel_none,obsData=mydata,verbose=T)
fitRequest_right <- hzar.first.fitRequest.old.ML(model=clineModel_right,obsData=mydata,verbose=T)
fitRequest_left <- hzar.first.fitRequest.old.ML(model=clineModel_left,obsData=mydata,verbose=T)
fitRequest_both <- hzar.first.fitRequest.old.ML(model=clineModel_both,obsData=mydata,verbose=T)
fitRequest_mirror <- hzar.first.fitRequest.old.ML(model=clineModel_mirror,obsData=mydata,verbose=T)

myfitlist_none <- hzar.chain.doSeq(hzar.request=fitRequest_none,count=3,collapse=F)
myfitlist_right <- hzar.chain.doSeq(hzar.request=fitRequest_right,count=3,collapse=F)
myfitlist_left <- hzar.chain.doSeq(hzar.request=fitRequest_left,count=3,collapse=F)
myfitlist_both <- hzar.chain.doSeq(hzar.request=fitRequest_both,count=3,collapse=F)
myfitlist_mirror <- hzar.chain.doSeq(hzar.request=fitRequest_mirror,count=3,collapse=F)


hzar.plot.cline(myfitlist_none[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.none)")
hzar.plot.cline(myfitlist_right[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.right)")
hzar.plot.cline(myfitlist_left[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.left)")
hzar.plot.cline(myfitlist_both[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.both)")
hzar.plot.cline(myfitlist_mirror[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.mirror)")

groupedData_none <- hzar.dataGroup.add(myfitlist_none)
groupedData_right <- hzar.dataGroup.add(myfitlist_right)
groupedData_left <- hzar.dataGroup.add(myfitlist_left)
groupedData_both <- hzar.dataGroup.add(myfitlist_both)
groupedData_mirror <- hzar.dataGroup.add(myfitlist_mirror)


AICc_none <- hzar.AICc.hzar.dataGroup(groupedData_none)
AICc_right <- hzar.AICc.hzar.dataGroup(groupedData_right)
AICc_left <- hzar.AICc.hzar.dataGroup(groupedData_left)
AICc_both <- hzar.AICc.hzar.dataGroup(groupedData_both)
AICc_mirror <- hzar.AICc.hzar.dataGroup(groupedData_mirror)

AICc_none
AICc_right
AICc_left
AICc_both
AICc_mirror

#Fit to data group to enable next steps
hzar.fit2DataGroup(myfitlist_none[[3]]) -> fit3_mtDNA_none
hzar.fit2DataGroup(myfitlist_right[[3]]) -> fit3_mtDNA_right
hzar.fit2DataGroup(myfitlist_left[[3]]) -> fit3_mtDNA_left
hzar.fit2DataGroup(myfitlist_both[[3]]) -> fit3_mtDNA_both
hzar.fit2DataGroup(myfitlist_mirror[[3]]) -> fit3_mtDNA_mirror


hzar.get.ML.cline(myfitlist_none[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_none[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_right[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_right[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_left[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_left[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_both[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_both[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_mirror[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_mirror[[3]])$param.all$center



#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_mtDNA_none,"width",2)
hzar.getLLCutParam(fit3_mtDNA_none,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_mtDNA_right,"width",2)
hzar.getLLCutParam(fit3_mtDNA_right,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_mtDNA_left,"width",2)
hzar.getLLCutParam(fit3_mtDNA_left,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_both,"width",2)
hzar.getLLCutParam(fit3_both,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_mtDNA_mirror,"width",2)
hzar.getLLCutParam(fit3_mtDNA_mirror,"center",2)

#PDF graph version of top model
pdf("RedFox_hzarcline_mtDNA.left.pdf",6,6)
hzar.plot.fzCline(fit3_mtDNA_left,xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)",main="RF.hzar.plot.cline(tails =left)")
#hzar.plot.cline(myfitlist_mtDNA[[3]],xlab="Smoothed coastline distance in km (AK to CA)",ylab="American mtDNA",main="hzar.plot.cline()")
dev.off()


#############################
#############################
#############################

nuDNA <- read.table("nuDNA-summary-noCotton.txt", header=T, stringsAsFactors=F) 


nuDNA <- read.table("NuDNA_SBD_18gens_100sims.txt", header=T, stringsAsFactors=F)


mydata <- hzar.doMolecularData1DPops(
  distance=nuDNA$dists,
  pObs=nuDNA$means,
  nEff=nuDNA$counts,
  siteID=nuDNA$LocIDs)

clineModel_none <- hzar.makeCline1DFreq(data=mydata,tails="none")
clineModel_none <- hzar.model.addCenterRange(clineModel_none, 0,1)
clineModel_none <- hzar.model.addMaxWidth(meta.model=clineModel_none,maxValue=1)

clineModel_right <- hzar.makeCline1DFreq(data=mydata,tails="right")
clineModel_right<- hzar.model.addCenterRange(clineModel_right, 0,1)
clineModel_right <- hzar.model.addMaxWidth(meta.model=clineModel_right,maxValue=1)

clineModel_left <- hzar.makeCline1DFreq(data=mydata,tails="left")
clineModel_left <- hzar.model.addCenterRange(clineModel_left, 0,1)
clineModel_left <- hzar.model.addMaxWidth(meta.model=clineModel_left,maxValue=1)

clineModel_both <- hzar.makeCline1DFreq(data=mydata,tails="both")
clineModel_both <- hzar.model.addCenterRange(clineModel_both, 0,1)
clineModel_both <- hzar.model.addMaxWidth(meta.model=clineModel_both,maxValue=1)

clineModel_mirror <- hzar.makeCline1DFreq(data=mydata,tails="mirror")
clineModel_mirror <- hzar.model.addCenterRange(clineModel_both, 0,1)
clineModel_mirror <- hzar.model.addMaxWidth(meta.model=clineModel_mirror,maxValue=1)



#Set initial pMin
0.0000 -> hzar.meta.init(clineModel_none)$pMin
#Set initial pMax
0.9995 -> hzar.meta.init(clineModel_none)$pMax

#Set initial pMin
0.0549 -> hzar.meta.init(clineModel_right)$pMin
#Set initial pMax
0.7423 -> hzar.meta.init(clineModel_right)$pMax

#Set initial pMin
0.0549 -> hzar.meta.init(clineModel_left)$pMin
#Set initial pMax
0.7423 -> hzar.meta.init(clineModel_left)$pMax

#Set initial pMin
0.0549 -> hzar.meta.init(clineModel_both)$pMin
#Set initial pMax
0.7423 -> hzar.meta.init(clineModel_both)$pMax

#Set initial pMin
0.0549 -> hzar.meta.init(clineModel_mirror)$pMin
#Set initial pMax
0.7423 -> hzar.meta.init(clineModel_mirror)$pMax



hzar.meta.fix(clineModel_none)$pMin <- TRUE
hzar.meta.fix(clineModel_none)$pMax <- TRUE

hzar.meta.fix(clineModel_right)$pMin <- TRUE
hzar.meta.fix(clineModel_right)$pMax <- TRUE

hzar.meta.fix(clineModel_left)$pMin <- TRUE
hzar.meta.fix(clineModel_left)$pMax <- TRUE

hzar.meta.fix(clineModel_both)$pMin <- TRUE
hzar.meta.fix(clineModel_both)$pMax <- TRUE

hzar.meta.fix(clineModel_mirror)$pMin <- TRUE
hzar.meta.fix(clineModel_mirror)$pMax <- TRUE


fitRequest_none <- hzar.first.fitRequest.old.ML(model=clineModel_none,obsData=mydata,verbose=T)
fitRequest_right <- hzar.first.fitRequest.old.ML(model=clineModel_right,obsData=mydata,verbose=T)
fitRequest_left <- hzar.first.fitRequest.old.ML(model=clineModel_left,obsData=mydata,verbose=T)
fitRequest_both <- hzar.first.fitRequest.old.ML(model=clineModel_both,obsData=mydata,verbose=T)
fitRequest_mirror <- hzar.first.fitRequest.old.ML(model=clineModel_mirror,obsData=mydata,verbose=T)

myfitlist_none <- hzar.chain.doSeq(hzar.request=fitRequest_none,count=3,collapse=F)
myfitlist_right <- hzar.chain.doSeq(hzar.request=fitRequest_right,count=3,collapse=F)
myfitlist_left <- hzar.chain.doSeq(hzar.request=fitRequest_left,count=3,collapse=F)
myfitlist_both <- hzar.chain.doSeq(hzar.request=fitRequest_both,count=3,collapse=F)
myfitlist_mirror <- hzar.chain.doSeq(hzar.request=fitRequest_mirror,count=3,collapse=F)


hzar.plot.cline(myfitlist_none[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.none)")
hzar.plot.cline(myfitlist_right[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.right)")
hzar.plot.cline(myfitlist_left[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.left)")
hzar.plot.cline(myfitlist_both[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.both)")
hzar.plot.cline(myfitlist_mirror[[3]],xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)", main="hzar.plot.cline(tails.mirror)")

groupedData_none <- hzar.dataGroup.add(myfitlist_none)
groupedData_right <- hzar.dataGroup.add(myfitlist_right)
groupedData_left <- hzar.dataGroup.add(myfitlist_left)
groupedData_both <- hzar.dataGroup.add(myfitlist_both)
groupedData_mirror <- hzar.dataGroup.add(myfitlist_mirror)


AICc_none <- hzar.AICc.hzar.dataGroup(groupedData_none)
AICc_right <- hzar.AICc.hzar.dataGroup(groupedData_right)
AICc_left <- hzar.AICc.hzar.dataGroup(groupedData_left)
AICc_both <- hzar.AICc.hzar.dataGroup(groupedData_both)
AICc_mirror <- hzar.AICc.hzar.dataGroup(groupedData_mirror)


#Fit to data group to enable next steps
hzar.fit2DataGroup(myfitlist_none[[3]]) -> fit3_nuDNA_none
hzar.fit2DataGroup(myfitlist_right[[3]]) -> fit3_nuDNA_right
hzar.fit2DataGroup(myfitlist_left[[3]]) -> fit3_nuDNA_left
hzar.fit2DataGroup(myfitlist_both[[3]]) -> fit3_nuDNA_both
hzar.fit2DataGroup(myfitlist_mirror[[3]]) -> fit3_nuDNA_mirror



hzar.get.ML.cline(myfitlist_none[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_none[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_right[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_right[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_left[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_left[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_both[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_both[[3]])$param.all$center

hzar.get.ML.cline(myfitlist_mirror[[3]])$param.all$width
hzar.get.ML.cline(myfitlist_mirror[[3]])$param.all$center



#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_nuDNA_none,"width",2)
hzar.getLLCutParam(fit3_nuDNA_none,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_nuDNA_right,"width",2)
hzar.getLLCutParam(fit3_nuDNA_right,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_nuDNA_left,"width",2)
hzar.getLLCutParam(fit3_nuDNA_left,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_nuDNA_both,"width",2)
hzar.getLLCutParam(fit3_nuDNA_both,"center",2)

#Extract center & +/- 2 LL range
hzar.getLLCutParam(fit3_nuDNA_mirror,"width",2)
hzar.getLLCutParam(fit3_nuDNA_mirror,"center",2)

#PDF graph version of top model
pdf("RedFox_hzarcline_nuDNA.none.pdf",6,6)
hzar.plot.fzCline(fit3_nuDNA_none,xlab="Geographic [South - North] Cline Distance (km)",ylab="Proportion of SVRF Ancestry (%)",main="RF.hzar.plot.cline(tails = none)")
#hzar.plot.cline(myfitlist_mtDNA[[3]],xlab="Smoothed coastline distance in km (AK to CA)",ylab="American mtDNA",main="hzar.plot.cline()")
dev.off()
