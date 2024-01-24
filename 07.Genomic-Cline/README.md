## Genomic Cline Analysis (bgc)

Only running this data on the Central Valley dataset (n=83)

Specifically used the K=2 assignment values from running Admixture with only these 83 individuals. Used stringent ancestry assignment parameters for the pure parental and only included those where 95% CIs deviated <0.05 from pure native or nonnative assignment. 

Resulted in: (SV: 18 red foxes; NN: 21 red foxes; Admx: 44 red foxes)

SV_Keep_99.9_se97.txt

NN_Keep_99.9_se97_new21.txt

Admixed_Keep_99.9_se97_new44.txt

Subset the main vcf file into three separate vcf files using these keep files

```
vcftools --vcf ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/populations.snps.vcf --keep ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/SV_Keep_99.9_se97.txt --recode --out ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/SV_Keep_99.9_se97_new18
vcftools --vcf ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/populations.snps.vcf --keep ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/NN_Keep_99.9_se97_new21.txt --recode --out ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/NN_Keep_99.9_se97_new21
vcftools --vcf ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/populations.snps.vcf --keep ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/Admixed_Keep_99.9_se97_new44.txt --recode --out ~/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/Admixed_Keep_99.9_se97_new44
```
Select a subset of Ancestry Informative Markers (AF difference >0.2) using genotypes in pure parental pops. 
```
setwd("C:/Users/Sophie/Desktop/Chapter1/BGC_GL_Test/UPDATED_V2_May2022")
vcf_genoSV <- read.table("SV_Keep_99.9_se97_new18.recode.vcf", stringsAsFactors = FALSE, header = TRUE)
vcf_genoNN <- read.table("NN_Keep_99.9_se97_new21.recode.vcf", stringsAsFactors = FALSE, header = TRUE)

#Subset the SNP Data and make a key for reference. 
#You can use either vcf file to do this they should output identical results

##subset the snp data
vcf_snps <- vcf_genoSV[,1:2]

##make a new column that is the snp_ID column
vcf_snps$snp_ID <- paste0(vcf_snps$CHROM,"_",vcf_snps$POS)

## add in a column that just reads the loci as locus 0, locus 1, etc...
## Note you need to update the below range to be 0:(#snps -1). For example, I have 14068 snps in this vcf file so I will set my range for locus labels from 0:140.
vcf_snps$locus_ID <- paste("locus", (0:14067))

##Export it as a reference and a key for later as all outputs from the bgc analysis will only read locus0, locus 1, etc.
write.csv(vcf_snps, "snp_key.csv")

##make a list of values that just has this new locus_ID info
vcf_snps_new <- vcf_snps[,-c(1:3)]

##Subset just the genotype data for the individuals into a new dataframe. Note this will need to be adjusted to 10:(10+(number of individuals-1)). 
vcf_SV_individual <- vcf_genoSV[, 10:27]
vcf_NN_individual <- vcf_genoNN[, 10:30]

#If your vcf file has been through plink/other filtering, it may already be in genotype only form without all the extra data. 
#If not, see the code below which will allow you to subset out just the first three characters (i.e. the genotype --> "0/1"). 
#Run the below code either way. It won't hurt and will flow better into the next batch of script.

#Just recording the code for one of these datasets (SV) You can repeat this script with the NN or Admixed but making minor tweaks described in the hashed out comments below.

library(dplyr)
library(stringr)

vcf_individual=vcf_SV_individual #change me accordingly

vcf_substr <- apply(vcf_individual, 2, function(x)substr(x,0,3))
str(vcf_substr)
vcf_data <- as.data.frame(vcf_substr)

dataset <- bind_cols(vcf_snps, vcf_data)

#Generate allele counts of the parental population.
dataset$string <- apply( dataset[ , c(5:22) ] , 1 , paste , collapse = "-" ) #change the numbers to reflect the columns where the genotypes are

##This counts the numner of 0s in each row of that column and assigns it to a new column called allele 0
dataset$allele0 <- str_count(dataset$string, "0")

##This counts the numner of 1s in each row of that column and assigns it to a new column called allele 1
dataset$allele1 <- str_count(dataset$string, "1")

##At this stage you can continue on making your BGC input file, or you can export the dataset objects of the two parental populations to determine allele frequency differences and subset out the data. 

write.table(dataset, "SV_99.9_se97_AF_Calculation.txt")

#I did some quick maneuvering in excel to turn these allele counts into allele frequencies and then came up with a list of SNPs that have a >0.2 difference in AF between SV and NN.
#You could easily modify this R script to do it as well though.

#Next you can either
#1)subset the original datasets by this new AIM dataset if you want to generate genotypes. Or..
#2)Utilize genotype likelihoods for everything 

#I opted to do the latter as bgc was not converging well when using called genotypes.

vcfP1 <- read.table("SV_Keep_99.9_se97_new18.recode.vcf", stringsAsFactors = FALSE, header = TRUE)
vcfP2 <- read.table("NN_Keep_99.9_se97_new21.recode.vcf", stringsAsFactors = FALSE, header = TRUE)
vcfAdmixed <- read.table("Admixed_Keep_99.9_se97_new44.recode.vcf", stringsAsFactors = FALSE, header = TRUE)
##subset the snp data
vcf_snps <- vcfP1[,1:2]

##make a new column that is the snnp_ID column
vcf_snps$snp_ID <- paste0(vcf_snps$CHROM,"_",vcf_snps$POS)

## add in a column that just reads the loci as locus 0, locus 1, etc...
## Note you need to update the below range to be 0:(#snps -1). For example, I have 2051snps in this vcf file so I will set my range for locus labels from 0:2650.
vcf_snps$locus_ID <- paste("locus", (0:14067))

##Export it as a reference and a key for later as all outputs from the bgc analysis will only read locus0, locus 1, etc.
write.csv(vcf_snps, "snp_key.csv")

##make a list of values that just has this new locus_ID info
vcf_snps_new <- vcf_snps[,-c(1:3)]

##Subset just the genotype data for the individuals into a new dataframe. Note this will need to be adjusted to 10:(10+(number of individuals-1)) for each input file. 
vcf_individual_P1 <- vcfP1[, 10:27]
vcf_individual_P2 <- vcfP2[, 10:30]
vcf_individual_Admixed <- vcfAdmixed[, 10:53]

#If your vcf file has been through plink/other filtering, it may already be in genotype only form without all the extra data. 
#If not, see the code below which will allow you to subset out the allele counts(from a raw vcf) if you want to use the genotype ikelohood method.

vcf_ReadDepth_P1 <- apply(vcf_individual_P1[,1:18],2,function(x) sapply(x, function(y) strsplit(y,split=":")[[1]][3]))
vcf_ReadDepth_P2 <- apply(vcf_individual_P2[,1:21],2,function(x) sapply(x, function(y) strsplit(y,split=":")[[1]][3]))
vcf_ReadDepth_Admixed <- apply(vcf_individual_Admixed[,1:44],2,function(x) sapply(x, function(y) strsplit(y,split=":")[[1]][3]))

vcf_data_P1 <- as.data.frame(vcf_ReadDepth_P1)
vcf_data_P2 <- as.data.frame(vcf_ReadDepth_P2)
vcf_data_Admixed <- as.data.frame(vcf_ReadDepth_Admixed)

library(dplyr)
library(stringr)
library(tidyr)
library(readr)

datasetP1 <- bind_cols(vcf_snps, vcf_data_P1)
datasetP2 <- bind_cols(vcf_snps, vcf_data_P2)
datasetAdmixed <- bind_cols(vcf_snps, vcf_data_Admixed)

##Replace blanks with 0,0
datasetP1[5:22] <- lapply(datasetP1[5:22], function(x) {x[x == '.'] <- '0,0';x})
datasetP2[5:25] <- lapply(datasetP2[5:25], function(x) {x[x == '.'] <- '0,0';x})
datasetAdmixed[5:48] <- lapply(datasetAdmixed[5:48], function(x) {x[x == '.'] <- '0,0';x})

#Subset data to only include the alleles with >0.2 allele frequencydifferences
AF_Diff_0.2 <- read.csv("AFDiff_0.2.csv", stringsAsFactors = FALSE, header = TRUE)

###Subset my original ones to only include these loci
P1_99.9_se97_AF0.2 <- subset(datasetP1, locus_ID %in% AF_Diff_0.2$locus_ID)
P2_99.9_se97_AF0.2 <- subset(datasetP2, locus_ID %in% AF_Diff_0.2$locus_ID)
Admixed_99.9_se97_AF0.2 <- subset(datasetAdmixed, locus_ID %in% AF_Diff_0.2$locus_ID)

#Adding in pop0-x is only needed for the hybrid population input file, not the parentals
##Add in a column for population "pop0"
Admixed_99.9_se97_AF0.2$pop <- paste("pop 0")

## For admixed dataset -- Move pop column next to locus column and remove the first couple of rows with locus specifics
Admixed_99.9_se97_AF0.2 <- subset(Admixed_99.9_se97_AF0.2, select=c(4,49,5:48))
#All_99.9_se97_AF0.2 <- subset(All_99.9_se97_AF0.2, select=c(4,88,5:87))

## For parental datasets -- just remove the first couple of rows with locus specifics
P1_99.9_se97_AF0.2 <- subset(P1_99.9_se97_AF0.2, select=c(4:22))
P2_99.9_se97_AF0.2 <- subset(P2_99.9_se97_AF0.2, select=c(4:25))


##Pivot data to long format
P1_pivot <- pivot_longer(P1_99.9_se97_AF0.2, 1:19, names_to = "pop", values_to = "genotype")
P2_pivot <- pivot_longer(P2_99.9_se97_AF0.2, 1:22, names_to = "pop", values_to = "genotype")
Admixed_pivot <- pivot_longer(Admixed_99.9_se97_AF0.2, 1:46, names_to = "pop", values_to = "genotype")

##Just keep genotype data
P1_genotypes <- subset(P1_pivot, select = c(2))
P2_genotypes <- subset(P2_pivot, select = c(2))
Admixed_genotypes <- subset(Admixed_pivot, select = c(2))

write.table(P1_genotypes, file = "P1_99.9_se97_AF0.2_GL.txt", quote = FALSE, row.names = FALSE)
write.table(P2_genotypes, file = "P2_99.9_se97_AF0.2_GL.txt", quote = FALSE, row.names = FALSE)
write.table(Admixed_genotypes, file = "Admixed_99.9_se97_AF0.2_GL.txt", quote = FALSE, row.names = FALSE)

##You may have to delete the first line of this file before running bgc if it outputs 'genotype' at the top.
#Also change the comma separators between the genotypes to a space separator. I just did this in a text editor.
```
Note that:
P1 = Sac Valley
P2 = Nonnative
Admixed = Admixed

Run 5 replicate chains each for 400k MCMC iterations with 200k burn-in thinning data every 40 steps. 

```
#!/bin/bash
#SBATCH -A ctbrowngrp
#SBATCH -t 20:00:00
#SBATCH -p bmm
#SBATCH --mem=50GB
#SBATCH -o /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/Admixed_50k100k_GL_Run1.out
#SBATCH -e /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/Admixed_50k100k_GL_Run1.err

~/bin/bgcdist/bgc -a /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/P1_99.9_se97_AF0.2_GL.txt -b /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/P2_99.9_se97_AF0.2_GL.txt -h /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/Admixed_99.9_se97_AF0.2_GL.txt -F AdmixedRF_50k100k_GL_Run1 -O 0 -x 100000 -n 50000 -N 1 -E 0.0001 -p 1 -q 1 -t 40 -I 1
```
Run estpost to extract output information for CLinePlotR from hdf5 file
```
#!/bin/bash
#SBATCH -A ctbrowngrp
#SBATCH -t 30:00:00
#SBATCH -p bmm
#SBATCH --mem=2GB
#SBATCH -o /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/100k200k14ksites/hdf5_extract.out
#SBATCH -e /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/Populations_CV_84RedFox/BayesianGenomicCline/Updated_May2022/100k200k14ksites/hdf5_extract.err

for i in {1..5}
do
#Run estpost to extract output information for CLinePlotR from hdf5 file
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p LnL -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_LnL_1 -s 2 -w 0
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p alpha -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_a0_1 -s 2 -w 0
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p beta -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_b0_1 -s 2 -w 0
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p gamma-quantile -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_qa_1 -s 2 -w 0
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p zeta-quantile -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_qb_1 -s 2 -w 0
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p hi -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_qb_1 -s 2 -w 0
#Run estpost to extract 95%CI from hdf5 file
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p alpha -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_a95_1.out -s 0 -c 0.95 -w 1
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p beta -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_b95_1.out -s 0 -c 0.95 -w 1
~/bin/bgcdist/estpost -i AdmixedRF_100k200k_14ksites_GL_Run${i}.hdf5 -p hi -o AdmixedRF_100k200k_14ksites_GL_Run${i}_bgc_stat_hi95_1.out -s 0 -c 0.95 -w 1
done
```
