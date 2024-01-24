## MDS Plot

```
#!/bin/bash
#SBATCH -t 10:00
#SBATCH -p high
#SBATCH --mem=50M
#SBATCH -o /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2_mind0.20.out
#SBATCH -e /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2_mind0.20.err

module load plink

plink --file /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2 --mind 0.20 --pca 3 --mds-plot 2 --cluster --allow-extra-chr --recode --out /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2_mind0.20
```

## Admixture

### All Samples
```
#!/bin/bash -l
#SBATCH -t 10:00:00
#SBATCH -p high
#SBATCH --mem=32G
#SBATCH -o "plink_mind0.76_geno0.2_mind0.20_Admixture.out"
#SBATCH -e "plink_mind0.76_geno0.2_mind0.20_Admixture.err"

for K in {1,2,3,4,5}; do ~/admixture_linux-1.3.0/admixture -B2000 --cv=10 /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2_mind0.20_ReplaceChr.bed $K | tee log${K}.out

done
```

### Central Valley Only (n = 84)

```
#!/bin/bash -l
#SBATCH -t 5:00:00
#SBATCH -p high
#SBATCH --mem=5G
#SBATCH -o "plink_mind0.76_geno0.2_mind0.20_CVOnly_Admixture.out"
#SBATCH -e "plink_mind0.76_geno0.2_mind0.20_CVOnly_Admixture.err"

for K in {1,2,3,4,5}; do ~/admixture_linux-1.3.0/admixture -B2000 --cv=10 /home/sophiepq/GBS_Runs1-4/stacks/outputs/StacksRun_LowlandCA_131/Populations_RedFox_LowlandCA_131_maf0.01moh0.6_wrs/plink_mind0.76_geno0.2_mind0.20_CVOnly_ReplaceChr.bed $K | tee log${K}.out

done
```
