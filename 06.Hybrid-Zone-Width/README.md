# Hybrid Zone Width

## Expected Cline Width (assuming neutral gene glow)

In order to run this you will also need the locations file [HZAM_HZAR_location_distances.csv](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Geographic-Cline/HZAM_HZAR_location_distances.csv).

* Simulate gene flow of maternally inherited mtDNA across the landscape using HZAM [SimulatedGeneFlow_mtDNA_Disp100%_100sims.R]()
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
* Simulate gene flow of biparentally inhertied nuDNA across the landscape using HZAM [SimulatedGeneFlow_nuDNA_Disp100%_100sims.R]()
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
* Estimate cline width using HZAR (simulated data)
  * [SimulatedClineWidth_nuDNA.R]
  * [SimulatedClineWidth_mtDNA.R]

## Observed Cline Width (using empirical data)

* Generate summary tables of the empirical data for use in HZAR cline models [EmpiricalData_SummaryTables.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Geographic-Cline/EmpiricalData_SummaryTables.R)

  * [ObservedClineWidths.R])()
