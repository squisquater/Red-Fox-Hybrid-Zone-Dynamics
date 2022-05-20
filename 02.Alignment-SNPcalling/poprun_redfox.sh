#!/bin/bash
#SBATCH -A ctbrowngrp
#SBATCH -t 4:00:00
#SBATCH -p bmh
#SBATCH --mem=64GB
#SBATCH -o poprun_redfox.out
#SBATCH -e poprun_redfox.err

module load stacks

populations -P $IN_FILEPATH -O $OUT_FILEPATH/outputfilename
--min-maf 0.01 --max-obs-het 0.60 --write-random-snp \
--structure --vcf --plink --radpainter --genepop --treemix \

# -P filepath to output of the previous script (refmap_PL_redfox.sh)
# -O path to and prefix for output filenames
# --min-maf 0.01 > set a minimum minor allele frequency of 0.01
# --max-obs-het 0.60 > set a max observed heterozygosity of 0.6 to remove paralogs
# --write-random-snp to reduce linkage (one snp per GBS locus)
