# Geographic Cline Analysis

## Expected Cline Width (assuming neutral gene glow)

Testing how many replicate simulations we need for both the mtDNA and nuDNA to eliminate the model variance (sample variance will remain).
* Ran a subset of simulation replicates (between 1:1000) for each marker type. To do this you need the simulation scripts (.R extension) for both the [mtDNA]() and the [nuDNA](). You will also need the locations file [HZAM_HZAR_location_distances.csv](). If you want to run these on a computing cluster you can also utilize the associated shell scripts (.sh extension). 


* Simulate gene flow of maternally inherited mtDNA across the landscape [SimulatedGeneFlow_mtDNA.R]
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
* Simulate gene flow of biparentally inhertied nuDNA across the landscape [SimulatedGeneFlow_nuDNA.R]
  * Assumes sex-biased dispersal
  * Assumes 18 generations (conservative estimate) of gene flow post contact
  
* Estimate cline width (simulated data)
  * [SimulatedClineWidth_nuDNA.R]
  * [SimulatedClineWidth_mtDNA.R]

## Observed Cline Width (using empirical data)

* Generate summary tables of the empirical data for use in HZAR cline models [EmpiricalData_SummaryTables.R](https://github.com/squisquater/Red-Fox-Hybrid-Zone-Dynamics/blob/main/06.Geographic-Cline/EmpiricalData_SummaryTables.R)

  * [ObservedClineWidth_nuDNA.R]
  * [ObservedClineWidth_mtDNA.R]
