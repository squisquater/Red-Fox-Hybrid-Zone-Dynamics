# Red-Fox-Hybrid-Zone-Dynamics
**Maintenance of a narrow hybrid zone between native and introduced red foxes despite conspecificity and high dispersal capabilities** 

<img align="center" src="/SVRF1.png" width="1000">

## **Sample Info**
* [SampleList.md](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/SampleList.md)

## Raw data location 
* link to data repository once uploaded

## **01. Data Processing**
* Demultiplexed [demux.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/demux.sh) 
* Trim reads [trim.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/trim.sh)
* Merge Duplicate Runs [merge_dup.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/merge_dup.sh)

## 02. Alignment & Initial SNP Calling
* Align to reference [align.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/02.Alignment-SNPcalling/align.sh)
* Stacks reference map SNP pipeline [refmap_PL_redfox.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/02.Alignment-SNPcalling/refmap_PL_redfox.sh)
* Run populations on output of above refmap pipeline [poprun_redfox.sh]()

## 03. SNP filtering
You can check out details on the Stacks populations filters [here]( http://catchenlab.life.illinois.edu/stacks/comp/populations.php) 

* Using data generated from the reference genome pipeline described above, we tested a variety of filtering approaches to maximimze the number of sites and individuals while removing low quality data. The pipeline here represents the approach described in the manuscript.
  * Remove the lowest quality individuals (>75% of SNPs missing) [plinkfilter_mind0.75.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.75.sh)
  * Remove sites that were called in <80% of individuals [plinkfilter_geno0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_geno0.2.sh)
  * Again remove lower quality individuals (>20% of SNPs missing) using a threshold based approach [plinkfilter_mind0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.2.sh)

## 04. Sex-Biased Dispersal Patterns
* See Preckler-Quisquater 2022

## 05. Geographic Ancestry Patterns

## 06. Geographic Cline

## 07. Genomic Cline
