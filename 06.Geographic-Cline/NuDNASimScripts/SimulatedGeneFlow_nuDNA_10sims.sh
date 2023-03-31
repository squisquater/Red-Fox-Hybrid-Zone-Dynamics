#!/bin/bash -l

# setting name of job
#SBATCH --job-name=SimulatedGeneFlow_nuDNA_10sims

# setting home directory
#SBATCH -D /group/ctbrowngrp3/scratch/sophiepq/scratch

# setting standard error output
#SBATCH -e /group/ctbrowngrp3/scratch/sophiepq/scratch/slurm_log/SimulatedGeneFlow_nuDNA_10sims_sterror_%j.txt

# setting standard output
#SBATCH -o /group/ctbrowngrp3/scratch/sophiepq/scratch/slurm_log/SimulatedGeneFlow_nuDNA_10sims_stdoutput_%j.txt

# setting medium priority
#SBATCH -p med

# setting the max time
#SBATCH -t 1:00:00

# mail alerts at beginning and end of job
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END

# send mail here
#SBATCH --mail-user=squisquater@ucdavis.edu

# now we'll print out the contents of the R script to the standard output file
cat SimulatedGeneFlow_nuDNA_10sims.R
echo "ok now for the actual standard output"

# now running the actual script!

# load R
module load R

srun Rscript SimulatedGeneFlow_nuDNA_10sims.R
