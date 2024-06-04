In this manuscript, we estimated the width of the hybrid zone between native and nonnative red foxes sampled in the southern Sacramento Valley and San Joaquin Valley and then compared this empirical estimate to expectations based on a null model that assumed no reproductive barriers and neutral diffusion for the duration of time the two populations were in contact at the southern end of the native range. 

We parameterized dispersal distances separately for males and females as 44.9 km (SD = 79.8 km) and 7.8 km (SD = 9.0 km), which allowed for sampling from a lognormal distribution that is more reflective of mammalian dispersal patterns. These dispersal estimates were derived using a genetic relatedness approach (Walton et al. 2021, Preckler-Quisquater 2022) and were similar to those for other lowland red fox populations (Phillips et al. 1972, Demaray et al. 1981, Gosselink et al. 2010, Walton et al. 2021). 

Detailed methods can be found in:

*Preckler-Quisquater, S. (2022). Genomic Analysis of Divergence and Secondary Contact in Red Foxes (Vulpes vulpes) and Gray Foxes (Urocyon cinereoargenteus). (PhD dissertation), University of California Davis, Davis, CA, United States.*

Briefly, we estimated dispersal distance of males and females separately by measuring straight line (Euclidean) distance between adult (> 7 months old) same-sex first-order relatives (parent-offspring or full-siblings) (Storm et al., 1976; Walton et al., 2021).  To obtain a relatedness (r) threshold that would confidently differentiate first-order (parent-offspring, full siblings) from second order (e.g., half-siblings) relatives and unrelated individuals, we simulated genotypes for individuals of known relatedness (r; parent-offspring, full-sibling, half-sibling, unrelated) at varying numbers of randomly selected loci (n = 100–500), using the allele frequencies present in our population. We then examined the distributions of r using the ‘quellergt’ estimator (Queller and Goodnight, 1989) in the R package ‘Related’ (Pew et al. 2015).  The simulations demonstrated that a cutoff of r = 0.40 resulted in correctly identifying all pairs of first-order relatives (100% sensitivity) and none of the half-siblings or unrelated individuals (100% specificity) when using a minimum of 400 loci. We therefore calculated estimates of r among the individuals in our study using 400 randomly selected loci in our genome-wide SNP (GBS) dataset.

The following tables show data from Preckler-Quisquater, 2022 used in this study

**Table 1.1:** Average dispersal distances for both male and female red foxes within the California lowlands as inferred from geographic distances between adult first-order relatives; first-order relatives were inferred from pairwise estimates of relatedness as those >0.4 Relatedness estimates were generated using a subset of 400 randomly selected genomic loci from the larger genotyping-by-sequencing (GBS) dataset (19,051 loci). Dispersal distance estimates were then compared to estimates from other populations obtained using several different approaches including capture/recapture (Philips et al. 1972; Demaray et al. 1981), radio telemetry (Gosselink et al. 2010), and genetic relatedness (Walton et al. 2021).  Estimates observed in the present study were within the range of other estimates for male vs. female dispersal patterns. 
| Estimation method   | Geographic location | Reference               | Sex             | Mean  | SD    | n   |
| ------------------- | ------------------- | ----------------------- | --------------- | ----- | ----- | --- |
| Genetic Relatedness | CA lowland          | New to this study       | male – male     | 44.9  | 79.75 | 5   |
| Genetic Relatedness | CA lowland          | New to this study       | female – female | 7.84  | 9.04  | 4   |
| Genetic Relatedness | CA lowland          | New to this study       | opposite sex    | 9.78  | 11.16 | 9   |
| Genetic Relatedness | Sweden              | Walton et al. (2021)    | male – male     | 37.79 | 55.54 | 38  |
| Genetic Relatedness | Sweden              | Walton et al. (2021)    | female – female | 6.17  | 12.45 | 64  |
| Genetic Relatedness | Sweden              | Walton et al. (2021)    | opposite sex    | 15.85 | 28.49 | 22  |
| Capture/Recapture   | Iowa/Illinois       | Phillips et al. (1972)  | male            | 29.6  | \-    | 171 |
| Capture/Recapture   | Iowa/Illinois       | Phillips et al. (1972)  | female          | 9.98  | \-    | 124 |
| Radio Telemetry     | Illinois/Indiana    | Gosselink et al. (2010) | male            | 44.6  | \-    | 69  |
| Radio Telemetry     | Illinois/Indiana    | Gosselink et al. (2010) | female          | 29.8  | \-    | 27  |
| Capture/Recapture   | South Dakota        | Demaray et al. (1981)   | male            | 59.5  | 66.3  | 9   |
| Capture/Recapture   | South Dakota        | Demaray et al. (1981)   | female          | 37.6  | 19.71 | 3   |

**Table S1.2:** Measurements of Euclidian distance between first-order relatives (Relatedness >0.4) used to generate estimates of male and female dispersal distances. Genetic relatedness between individuals was determined using the Queller and Goodnight estimator (1989) in the R package 'Related' (Pew et al. 2015) and a random subset (n = 400) of the 19,051 GBS loci. 
| **Ind.1** | **Ind.1.sex** | **Ind.2** | **Ind.2.sex** | **Distance (km)** | **quellergt** | **Used in dispersal Estimation** | **Reason for exclusion** |
| --------- | ------------- | --------- | ------------- | ----------------- | ------------- | -------------------------------- | ------------------------ |
| S14-0843  | Unknown       | S14-0887  | Male          | NA                | 0.949         | No                               | replicate individual?    |
| S19-1797  | Unknown       | S19-1798  | Unkown        | NA                | 0.7161        | No                               | littermates (<6 months)  |
| MAM-2703  | Male          | MAM-2706  | Female        | NA                | 0.6948        | No                               | littermates (<6 months)  |
| S12-0016  | Male          | S13-1971  | Female        | 6.48              | 0.6929        | Male-Female                      |                          |
| ESRP-R008 | Unknown       | ESRP-R009 | Male          | NA                | 0.6901        | No                               | Undeterined sex          |
| S10-0562  | Male          | S10-0565  | Male          | 186.60            | 0.6527        | Male-Male                        |                          |
| MAM-3675  | Female        | MAM-3687  | Female        | 4.28              | 0.6454        | Female-Female                    |                          |
| S14-0856  | Female        | S14-0872  | Female        | 8.92              | 0.6018        | Female-Female                    |                          |
| S07-0171  | Male          | S07-0172  | Male          | NA                | 0.5992        | No                               | littermates (<6 months)  |
| MAM-2705  | Male          | MAM-2704  | Male          | NA                | 0.5925        | No                               | littermates (<6 months)  |
| S08-0535  | Male          | S13-1971  | Female        | 0.13              | 0.5737        | Male-Female                      |                          |
| S17-2550  | Female        | S18-2200  | Female        | 1.33              | 0.5615        | Female-Female                    |                          |
| S09-0779  | Female        | S09-0268  | Male          | 1.25              | 0.5447        | Male-Female                      |                          |
| S14-0850  | Male          | S14-0867  | Male          | 4.86              | 0.541         | Male-Male                        |                          |
| MAM-2708  | Male          | S14-0882  | Male          | 25.16             | 0.539         | Male-Male                        |                          |
| S09-0440  | Male          | S10-0513  | Female        | 23.05             | 0.5239        | Male-Female                      |                          |
| S09-0280  | Male          | S09-0440  | Unkown        | NA                | 0.5188        | No                               | littermates (<6 months)  |
| S08-0535  | Male          | S12-0016  | Male          | 6.46              | 0.5033        | Male-Male                        |                          |
| S19-1800  | Unknown       | S19-1798  | Unkown        | NA                | 0.4995        | No                               | littermates (<6 months)  |
| S17-2549  | Male          | S18-2200  | Female        | 0.22              | 0.4874        | Male-Female                      |                          |
| S10-0188  | Male          | S10-0191  | Male          | NA                | 0.4859        | No                               | littermates (<6 months)  |
| S09-0280  | Male          | S10-0513  | Female        | 23.05             | 0.4791        | Male-Female                      |                          |
| S17-2549  | Male          | S17-2550  | Female        | 1.55              | 0.4554        | Male-Female                      |                          |
| MAM-2705  | Male          | MAM-2706  | Female        | 2.22              | 0.435         | Male-Female                      |                          |
| S19-1800  | Unknown       | S19-1797  | Unkown        | NA                | 0.4338        | No                               | littermates (<6 months)  |
| S14-0855  | Female        | S14-0861  | Female        | 7.31              | 0.4291        | Female-Female                    |                          |
| S12-0285  | Unknown       | S12-0286  | Unkown        | NA                | 0.4087        | No                               | littermates (<6 months)  |
| ESRP-R006 | Female        | S14-0863  | Male          | 27.09             | 0.4019        | Male-Female                      |                          |
| MAM-2736  | Male          | S14-0882  | Male          | 1.43              | 0.4163        | Male-Male                        |                          |
| MAM-3675  | Female        | MAM-3686  | Male          | 3.25              | 0.412         | Male-Female                      |                          |
| S19-1797  | Unknown       | S19-1798  | Unkown        | NA                | 0.7161        | No                               | littermates (<6 months)  |
|           |               |           |               |                   |               |                                  |                          |

