## This script generates the summary tables needed to run HZAR
## mean and sampling variance at each location along the cline transect

setwd("~/Desktop/RedFox-SVNN-Manuscript/HZAR")

###########
##mtDNA####
###########

mtDNA_emp <- read.csv("GeogClineData-mtDNA-20230303.csv", header=T, stringsAsFactors=F)


### Need to add a new column to the matrix that assigns a location bin to the data ###
mtDNA_emp$LocSummary <- findInterval(mtDNA_emp$ScaledClineLocation, c(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1), rightmost.closed = TRUE)  


##quick plot
plot(mtDNA_emp$LocSummary, mtDNA_emp$mtDNA
     )

##Calculate the mean and Standard Error of each bin

##Make a list of the LocSummaries note these are not characters right now...
LocIDs <- mtDNA_emp$LocSummary

p <- mtDNA_emp$mtDNA

#Read in distances of "sampling locations"
d <- read.csv("GeogCline-SamplingIntervals-mtDNA.csv", header=T, stringsAsFactors=F)

## Output vector of distances
d$distance -> dists

## Get population means
sapply(unique(LocIDs),function(x){mean(p[which(LocIDs %in% x)])},USE.NAMES=F) %>% round(4) -> means
means

## Get population variances
sapply(unique(LocIDs),function(x){var(p[which(LocIDs %in% x)])},USE.NAMES=F) -> vars

## Get population counts
sapply(unique(LocIDs),function(x){length(p[which(LocIDs %in% x)])},USE.NAMES=F) -> counts

## Create data frame for input into Hzar
data.frame(LocIDs=unique(LocIDs),dists,means,vars,counts) -> m

write.table(m, file="mtDNA-summary-20230303.txt")

plot(m$LocIDs,m$means)


p <- ggplot(m, aes(x=LocIDs, y=means)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=means-vars, ymax=means+vars))

p  


#############
###Nuclear### 
#############

### Need to add a new column to the matrix that assigns a location bin to the data ###

Nuclear <- read.csv("GeogClineData-nuDNA-20230301.csv", header=T, stringsAsFactors=F)
Nuclear$LocSummary <- findInterval(Nuclear$ScaledClineLocation, c(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1), rightmost.closed = TRUE)  

##quick plot
plot(Nuclear$LocSummary, Nuclear$NativeAncestry)

##Calculate the mean and Standard Error of each bin

##Make a list of the LocSummaries note these are not characters right now...
LocIDs <- Nuclear$LocSummary

p <- Nuclear$NativeAncestry

#Read in distances of "sampling locations"
d <- read.csv("GeogCline-SamplingIntervals-nuDNA-20230303.csv", header=T, stringsAsFactors=F)

## Output vector of distances
d$distance -> dists

## Get population means
sapply(unique(LocIDs),function(x){mean(p[which(LocIDs %in% x)])},USE.NAMES=F) %>% round(4) -> means
means

## Get population variances
sapply(unique(LocIDs),function(x){var(p[which(LocIDs %in% x)])},USE.NAMES=F) -> vars

## Get population counts
sapply(unique(LocIDs),function(x){length(p[which(LocIDs %in% x)])},USE.NAMES=F) -> counts

## Create data frame for input into Hzar
data.frame(LocIDs=unique(LocIDs),dists,means,vars,counts) -> m

m

write.table(m, file="nuDNA-summary-20230301.txt")

plot(m$LocIDs,m$means)

p <- ggplot(m, aes(x=LocIDs, y=means, ymin=0, ymax=1)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=means-vars, ymax=means+vars)) +
  theme() +
  theme_classic()

p  
