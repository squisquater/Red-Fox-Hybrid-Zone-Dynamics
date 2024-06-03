# Hybrid Zone Width

## Expected Cline Width (assuming neutral gene glow)

In order to run this you will also need:
* The locations file [HZAM_HZAR_location_distances.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/HZAM_HZAR_location_distances.csv).

01. Simulate gene flow of maternally inherited mtDNA across the landscape using HZAM [SimulatedGeneFlow_mtDNA_Disp100%_100sims.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/SimulatedGeneFlow_mtDNA_Disp100%25_100sims.R)
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
02. Simulate gene flow of biparentally inhertied nuDNA across the landscape using HZAM [SimulatedGeneFlow_nuDNA_Disp100%_100sims.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/SimulatedGeneFlow_nuDNA_Disp100%25_100sims.R)
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
03. Estimate cline widths for both mtDNA and nuDNA using HZAR (simulated data)
  * [SimulatedClineWidth_nuDNA.R]()
  * [SimulatedClineWidth_mtDNA.R]()

## Observed Cline Width (using empirical data)
In order to run this you will need:
* The empirical cline data for mtDNA: [GeogClineData-mtDNA.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogClineData-mtDNA.csv)
* The empirical cline data for nuDNA: [GeogClineData-nuDNA.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogClineData-nuDNA.csv)
* Sampling Intervals for [mtDNA](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogCline-SamplingIntervals-mtDNA.csv) and [nuDNA](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/GeogCline-SamplingIntervals-nuDNA.csv)

01. Generate summary tables of the empirical data for use in HZAR cline models [EmpiricalData_SummaryTables.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/EmpiricalData_SummaryTables.R)

3. Estimate cline widths for both mtDNA and nuDNA using HZAR (empirical data)
 * [ObservedClineWidths.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Hybrid-Zone-Width/ObservedClineWidths.R)
