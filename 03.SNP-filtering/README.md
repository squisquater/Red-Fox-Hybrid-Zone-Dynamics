## SNP filtering
You can check out details on the Stacks populations filters [here]( http://catchenlab.life.illinois.edu/stacks/comp/populations.php) 

* Using data generated from the reference genome pipeline described above, we tested a variety of filtering approaches to maximimze the number of sites and individuals while removing low quality data. The pipeline here represents the approach described in the manuscript.
  * Remove the lowest quality individuals (>75% of SNPs missing) [plinkfilter_mind0.75.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.75.sh)
  * Remove sites that were called in <80% of individuals [plinkfilter_geno0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_geno0.2.sh)
  * Again remove lower quality individuals (>20% of SNPs missing) using a threshold based approach [plinkfilter_mind0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.2.sh)
