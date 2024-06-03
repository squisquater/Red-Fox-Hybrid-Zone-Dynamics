# Maintenance of a narrow hybrid zone between native and introduced red foxes (Vulpes vulpes) despite conspecificity and high dispersal capabilities

<img align="center" src="/SVRF1.png" width="1000">

This dataset was used to generate results for the following manuscript which has been accepted in the Journal of Molecular Ecology (May 13th, 2024)

**Preckler-Quisquater S., Quinn C.B., Sacks B.N. (2024) Maintenance of a narrow hybrid zone between native and introduced red foxes (Vulpes vulpes) despite conspecificity and high dispersal capabilities. Molecular Ecology.**

**ABSTRACT** \
*Human-facilitated introductions of nonnative populations can lead to secondary contact between allopatric lineages, resulting in lineage homogenization or the formation of stable hybrid zones maintained by reproductive barriers. We investigated patterns of gene flow between the native Sacramento Valley red fox (Vulpes vulpes patwin) and introduced conspecifics of captive-bred origin in California’s Central Valley. Considering their recent divergence (20–70 kya), we hypothesized that any observed barriers to gene flow were primarily driven by pre-zygotic (e.g., behavioral differences) rather than post-zygotic (e.g., reduced hybrid fitness) barriers. We also explored whether nonnative genes could confer higher fitness in the human-dominated landscape resulting in selective introgression into the native population. Genetic analysis of red foxes (n = 682) at both mitochondrial (cytochrome b + D-loop) and nuclear (19,051 SNPs) loci revealed narrower cline widths than expected under a simulated model of unrestricted gene flow, consistent with the existence of reproductive barriers. We identified several loci with reduced introgression that were previously linked to behavioral divergence in captive-bred and domestic canids, supporting pre-zygotic, yet possibly hereditary, barriers as a mechanism driving the narrowness and stability of the hybrid zone. Several loci with elevated gene flow from the nonnative into the native population were linked to genes associated with domestication and adaptation to human dominated landscapes.  This study contributes to our understanding of hybridization dynamics in vertebrates, particularly in the context of species introductions and landscape changes, underscoring the importance of considering how multiple mechanisms may be maintaining lineages at the species and subspecies level.* 

## Description of the data and file structure

This repository contains data and scripts required to recreate analyses in the manuscript *Maintenance of a narrow hybrid zone between native and introduced red foxes (Vulpes vulpes) despite conspecificity and high dispersal capabilities *which has been accepted into the Journal of Molecular Ecology as of May 13th, 2024.

The raw GBS sequencing data associated with this study can be found in the NCBI Sequence Read Archive under project number:

**PRJNA1069152** : Reduced-representation genotyping-by-sequencing of low-elevation red foxes in California


**Maintenance of a narrow hybrid zone between native and introduced red foxes despite conspecificity and high dispersal capabilities** 

## **Sample Info**
* [SampleList.md](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/SampleList.md)
* **Table S1.** Information for red fox DNA samples from the Sacramento Valley, San Joaquin Valley, and Coastal Lowlands of California, USA, used in this study, including sample type (tissue, scat, etc.), geographic location (latitude, longitude), year collected, mitochondrial DNA haplotype and ancestry (native vs nonnative), whether samples were included in nuclear genotyping-by- sequencing (GBS) and whether they passed basic quality filtering (GBS Success), geographic range delineation, and citations for samples that were previously described in other studies.

## Raw data location 
The raw GBS sequencing data associated with this study can be found in the NCBI Sequence Read Archive under project number:

**PRJNA1069152** : Reduced-representation genotyping-by-sequencing of low-elevation red foxes in California

## **01. Data Processing**
* Demultiplex Data [demux.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/demux.sh) 
* Trim reads [trim.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/trim.sh)
* Merge Duplicate Runs [merge_dup.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/01.Data-Processing/merge_dup.sh)

## 02. Alignment & Initial SNP Calling
* Align to reference [align.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/02.Alignment-SNPcalling/align.sh)
* Stacks reference map SNP pipeline [refmap_PL_redfox.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/02.Alignment-SNPcalling/refmap_PL_redfox.sh)
* Run populations on output of above refmap pipeline [poprun_redfox.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/02.Alignment-SNPcalling/poprun_redfox.sh)

## 03. Data filtering
You can check out details on the Stacks populations filters [here]( http://catchenlab.life.illinois.edu/stacks/comp/populations.php) 

* Using data generated from the reference genome pipeline described above, we tested a variety of filtering approaches to maximimze the number of sites and individuals while removing low quality data. The pipeline here represents the approach described in the manuscript.
  * Remove the lowest quality individuals (>75% of SNPs missing) [plinkfilter_mind0.75.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.75.sh)
  * Remove sites that were called in <80% of individuals [plinkfilter_geno0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_geno0.2.sh)
  * Again remove lower quality individuals (>20% of SNPs missing) using a threshold based approach [plinkfilter_mind0.2.sh](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/03.SNP-filtering/plinkfilter_mind0.2.sh)

## 05. Geographic Patterns of Ancestry
See [README.md](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/tree/main/05.Geographic-Ancestry-Patterns)
* MDS Plot
* Admixture (K=1-5)

## 06. Width of the Hybrid Zone
### Expected Cline Width (assuming neutral gene glow)

In order to run this you will also need:
* The locations file [HZAM_HZAR_location_distances.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/HZAM_HZAR_location_distances.csv).

01. Simulate gene flow of maternally inherited mtDNA across the landscape using HZAM [SimulatedGeneFlow_mtDNA_Disp100%_100sims.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/SimulatedGeneFlow_mtDNA_Disp100%25_100sims.R)
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
02. Simulate gene flow of biparentally inhertied nuDNA across the landscape using HZAM [SimulatedGeneFlow_nuDNA_Disp100%_100sims.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/SimulatedGeneFlow_nuDNA_Disp100%25_100sims.R)
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
03. Estimate cline widths for both mtDNA and nuDNA using HZAR (simulated data)
  * [SimulatedClineWidths.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/SimulatedClineWidths.R)

### Observed Cline Width (using empirical data)
In order to run this you will need:
* The empirical cline data for mtDNA: [GeogClineData-mtDNA.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogClineData-mtDNA.csv)
* The empirical cline data for nuDNA: [GeogClineData-nuDNA.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogClineData-nuDNA.csv)
* Sampling Intervals for [mtDNA](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogCline-SamplingIntervals-mtDNA.csv) and [nuDNA](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogCline-SamplingIntervals-nuDNA.csv)

01. Generate summary tables of the empirical data for use in HZAR cline models [EmpiricalData_SummaryTables.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/EmpiricalData_SummaryTables.R)

3. Estimate cline widths for both mtDNA and nuDNA using HZAR (empirical data)
 * [ObservedClineWidths.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/ObservedClineWidths.R)

## 07. Genomic Cline Analysis
* Bayesian Genomic Cline - See [README.md](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/tree/main/07.Genomic-Cline)
