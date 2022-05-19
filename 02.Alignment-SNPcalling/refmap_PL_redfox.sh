#!/bin/bash -l
#SBATCH -t 8-10:00:00
#SBATCH -p bigmemm
#SBATCH --mem 128GB
#SBATCH -o "refmap_PL_redfox.out"

module load stacks

ref_map.pl -T 1 --samples ~/GBS_Runs1-4/trimmed_fastq/ --popmap ~/GBS_Runs1-4/popmaps/popmap.txt --unpaired -o ~/GBS_Runs1-4/stacks/outputs/outputfilename

# [--samples] list path to directory with fastq files
# [--popmap]  list path to popmap
#             Note: popmap is two columns. 
#                 column1: fastq file prefix(sampleID) 
#                 column2: Population ID (user defined)
# [--unpaired] denotes that the data are single end reads as opposed to paired end
