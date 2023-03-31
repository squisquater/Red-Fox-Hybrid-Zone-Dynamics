# HZAM_release_2.0.R
# Hybrid Zone Assortative Mating (HZAM) model
# To model the effects of assortative mating and low hybrid fitness on hybrid zone width, stability, and dynamics.
# Started by Darren Irwin on 8 May, 2014, on Bowen Island, BC.
# Released by Darren Irwin, November 2019, University of British Columbia, Biodiversity Research Centre and Dept. of Zoology.

# Data produced using this HZAM script is presented in the following paper: 
# Irwin, D.E. Assortative mating in hybrid zones is remarkably ineffective in promoting speciation. American Naturalist, accepted pending minor revision, Nov. 2019.

# A very similar paper, with all of the same data and graphs, was earlier posted on bioRxiv:
# Irwin, D.E. 2019. Assortative mating in hybrid zones is remarkably ineffective in promoting speciation. bioRxiv doi: https://doi.org/10.1101/637678

# If you use this script and or the data it relates to, please cite one of the papers above (preferably the AmNat paper).

# Questions: Email Darren at irwin@zoology.ubc.ca

##Modifications to this script generated for this paper include
### Sex-Biased Dispersal 
### Dispersal Parameter for each individual is sampled from a LogNormal Distribution as opposed to a normal distribution

# Starting setup ----

#install.packages("viridis")
#install.packages("mgcv")
#install.packages("boot")
#install.packages("magick")
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("ggplot2")


library(viridis)
library(mgcv)  #needed for gam command
library(boot)  #needed for the inv.logit command
library(magick)
library(plyr)
library(dplyr)
library(ggplot2)

# Main script ----

# option to run a bunch of simulations consecutively

run_set_name <- "NuDNA_100loci_SBD_44.9_7.84_18gens_NewHZBorder_20230330_150sims"  # provide a name for this set of runs, which will be in the filenames

# maximum fitness of maximal heterozygote compared to pure forms
hybrid_fitness_set <- c(1)   # for just one run, just put one number in this and next line
pref_ratio_set <- c(0.999999)   # ratio in mating pref between hetero- and homospecific
# note the 0.999999 is essentially 1.0, but the latter is not allowed by the math (pref_ratio_set must be between zero and one)

# make sure the random number seed is not set, and instead is based on system time:
set.seed(NULL)

# Choose parameter states
K_half <- 4236  # carrying capacity of entire range (for each sex); overall K is twice this, with sexes combined (4236 for Red Foxe)
max_generations <- 18;  # the time at which the simulation will stop 
#meandispersal <- 0.0216625  

## Male
m <- 0.0711 #equivalent to 44.9km/631.78km  
s <- 0.1262 #equivalent to 79.75km/631.78km  
location <- log(m^2 /sqrt(s^2 + m^2))
shape <- sqrt(log(1 + (s^2 / m^2)))
print(paste("location:", location)) #location: -3.35528236795758
print(paste("shape:", shape)) #shape: 1.19299155553142
draws3 <- rlnorm(n=1000000, location, shape)
mean(draws3)
sd(draws3)
male.plot <- plot(density(draws3[draws3 < 1]))

## Female
m <- 0.0124 #equivalent to 7.84km/631.78km
s <- 0.0143 #equivalent to 9.04km/631.78km
location <- log(m^2 /sqrt(s^2 + m^2))
shape <- sqrt(log(1 + (s^2 / m^2)))
print(paste("location:", location)) #location: -4.8129778671143
print(paste("shape:", shape)) #shape: 0.919694580546335
draws3 <- rlnorm(n=1000000, location, shape)
mean(draws3)
sd(draws3)
plot(density(draws3[draws3 < 1]))

# using log normal disperal with different meanlog and sdlogs for males and females
meanlog_M <- -3.35528236795758
sdlog_M <- 1.19299155553142
meanlog_F <- -4.8129778671143
sdlog_F <- 0.919694580546335


# quick test of disperal distributions
hist(rlnorm(1000, meanlog_M, sdlog_M), breaks=100)
hist(rlnorm(1000, meanlog_F, sdlog_F), breaks=20, col="red", add=TRUE)


##Turned off all plotting scripts because I will instead summarize the data at the end and use the HZAR program to better fit clines in order to better compare to empirical cline data which is not as clean and sigmoidal. 

do_plot <- F # whether to do plot during sims
plot_MTL <- F  # whether to plot Mating Trait Loci
plot_UDL <- F  # whether to plot UnderDominant Loci
plot_NL <- T  # whether to plot Neutral Loci
plot_density <- F   # T (or F) to show (not show) density plot
plot_int <- 1 # plotting intervals, in generations  (also will fit cline at these intervals)
make_movie <- F   # set whether to make a movie (T or F)
movie_gen <- seq(1,10, by=1)  # applies only if making a movie
movie_name <- "movie_temp"  
fit_to_cline <- F  # choose whether to fit a model at end
cline <- "UDL and NL"  # choose UDL or MTL or "UDL and NL" (for two clines)
fit_to_cline_during <- F  # choose whether to fit a cline model at each time plotted
width_method <- "eightieth"   # choose "tangent" or "eightieth" percentile in middle  ("tangent" may not work well)

survival_fitness_method <- 1  # option 1: underdominance only; option 2: epistasis (model of Barton & Gale 1993, Fig. 2-2) 
beta <- 1  # The beta value in the epistatic fitness equation: w(x) = 1 - s(4x[1-x])^beta

range_limit_left <- 0
range_limit_right <- 1 
per_reject_cost <- 0  # proportion reduction in fitness due to search cost, per rejected male (compounded).
growth_rate <- 1.05    # 1.1   # the average maximum expected number of offspring per individual, when pop size far below K
sigma_comp <- 0.0001  # the standard deviation (in units of space) of the density dependence effect

# define starting ranges (Note in my model the southern border of the Sacramento Valley is = 0.6801 
pop1_range_limit_left <- 0
pop1_range_limit_right <- 0.6677 #(421.85km/631.78km)
pop2_range_limit_left <- 0.6677  #(421.85km/631.78km)
pop2_range_limit_right <- 1

beginning_columns <- 1  # number of initial columns in matrix containing data such as location
male_trait_loci <- 0  # number of loci determining male trait (and female trait too if assort_mating=1)
assort_mating <- 0   # set for 1 if male trait and female trait are determined by same loci (zero otherwise) 
female_trait_loci <- 0  # if assort_mating = 1, then will automatically be equal to male_trait_loci, as they are the same loci; otherwise, this is number of loci determining female 'trait' (her ideal male trait)
underdominant_loci <- 0  # number of loci in which hybrids selected against
same_loci_MTL_UDL <- TRUE   # set to TRUE if the UDL loci are the same as the MTL loci; set to false if different loci
neutral_loci <- 100  # number of neutral loci (used for neutral measure of hybrid index)

mating_trait_loci_dominant <- F  # set to T to make mating loci encode trait in completeley dominant / recessive way, Otherwise additive.

# set colours for graphing
UDL_colour <- "seagreen"
MTL_colour <- "purple"
UDLMTL_colour <- "green4"  # tried a lot of greens, and green4 seems best
NL_colour <- "gray70"
#set colours of dots on graphs:
if (same_loci_MTL_UDL == T) {
  UDL_colour <- UDLMTL_colour
  MTL_colour <- UDLMTL_colour
}

# set up locations every 0.001 across range, and calculate density at each when 2K individuals are perfectly spaced:
spaced_locations <- round(seq(from = range_limit_left, to = range_limit_right, length.out = 1001), digits=3)  # the round is needed to ensure only 3 decimal places, avoiding error later
ind_locations_if_even_at_K <- seq(from = range_limit_left, to = range_limit_right, length.out = 2*K_half)
get_density_if_even_at_K <- function(focal_location) {
  return(sum(exp(-((ind_locations_if_even_at_K - focal_location)^2)/(2*(sigma_comp^2)))))
} 
ideal_densities_at_spaced_locations <- sapply(spaced_locations, get_density_if_even_at_K)

##make an empty matrix for the data to go into after each loop of the simulation 

Big_matrix_F <- matrix(nrow = 0, ncol = 1 + beginning_columns + 2*neutral_loci)
Big_matrix_M <- matrix(nrow = 0, ncol = 1 + beginning_columns + 2*neutral_loci)

###############################################
###############################################
## Loop throught the different simulation sets:
###############################################
###############################################
for (i in 150) {
  
  for (hybrid_fitness_case in 1:length(hybrid_fitness_set)) {
    for (pref_ratio_case in 1:length(pref_ratio_set)) {
      hybrid_fitness <- hybrid_fitness_set[hybrid_fitness_case]
      pref_ratio <- pref_ratio_set[pref_ratio_case]
      
      run_name <- paste0("HZAM_animation_prefratio",pref_ratio,"_hybridfitness",hybrid_fitness,"_K",K_half,"_UDLMTL",male_trait_loci,"_gen",max_generations,"_clinefitUDLNL_w80_run",run_set_name)
      
      pref_SD <- sqrt( -1 / (2 * log(pref_ratio)))     # width of female acceptance curve for male trait
      
      s_per_locus <- 1 - hybrid_fitness^(1/underdominant_loci)  # loss in fitness due to each heterozygous locus
      
      # each locus has two alleles, so takes up two columns
      # for clarity later, calculate start and end columns for each locus type
      MTL_col_start <- beginning_columns + 1
      MTL_col_end <- beginning_columns + 2*male_trait_loci
      if (assort_mating == 1) {
        FTL_col_start <- MTL_col_start
        FTL_col_end <- MTL_col_end
      }
      if (assort_mating == 0) {
        FTL_col_start = MTL_col_end + 1
        FTL_col_end = MTL_col_end + 2*female_trait_loci
      }
      if (same_loci_MTL_UDL == TRUE) {
        UDL_col_start <- FTL_col_start
        UDL_col_end <- FTL_col_end
      }
      if (same_loci_MTL_UDL == FALSE) {
        UDL_col_start <- FTL_col_end + 1
        UDL_col_end <- FTL_col_end + 2*underdominant_loci
      }
      NL_col_start <- UDL_col_end + 1
      NL_col_end <- UDL_col_end + 2*neutral_loci
      total_loci <- (NL_col_end - beginning_columns)/2
      
      # Set up starting conditions
      
      pop1_starting_N <- round(K_half * (pop1_range_limit_right - pop1_range_limit_left))  # remember that K_half is for each sex, so whole pop is 2K, divided among the two species
      pop2_starting_N <- round(K_half * (pop2_range_limit_right - pop2_range_limit_left))
      starting_N <- pop1_starting_N + pop2_starting_N
      
      # generate the population of females
      pop_matrix_F = matrix(-9, nrow=starting_N, ncol=1+2*total_loci) # create matrix to store population locations and genotypes; columns in this order: location, genotype columns
      # generate starting values for pop1:
      pop_matrix_F[1:pop1_starting_N,1] <- runif(n=pop1_starting_N, min=pop1_range_limit_left, max=pop1_range_limit_right)  # assigns random locations for pop1
      pop_matrix_F[1:pop1_starting_N,2:(1+2*total_loci)] <- 0   # assigns genotypes of pop1
      # generate starting values for pop2:
      pop_matrix_F[(1+pop1_starting_N):starting_N,1] <- runif(n=pop2_starting_N, min=pop2_range_limit_left, max=pop2_range_limit_right)  # assigns random locations for pop2
      pop_matrix_F[(1+pop1_starting_N):starting_N,2:(1+2*total_loci)] <- 1   # assigns genotypes of pop2
      
      # generate the population of males
      pop_matrix_M = matrix(-9, nrow=starting_N, ncol=1+2*total_loci) # create matrix to store population locations and genotypes; columns in this order: location, genotype columns
      # generate starting values for pop1:
      pop_matrix_M[1:pop1_starting_N,1] <- runif(n=pop1_starting_N, min=pop1_range_limit_left, max=pop1_range_limit_right)  # assigns random locations for pop1
      pop_matrix_M[1:pop1_starting_N,2:(1+2*total_loci)] <- 0   # assigns genotypes of pop1
      # generate starting values for pop2:
      pop_matrix_M[(1+pop1_starting_N):starting_N,1] <- runif(n=pop2_starting_N, min=pop2_range_limit_left, max=pop2_range_limit_right)  # assigns random locations for pop2
      pop_matrix_M[(1+pop1_starting_N):starting_N,2:(1+2*total_loci)] <- 1   # assigns genotypes of pop2
      
      # set up plot
      
      if (plot_density) {
        quartz(title=paste0("HZAM; pref_ratio=", pref_ratio,"; hybrid_fitness=", hybrid_fitness, sep=""), width=6, height=6, bg="white")
        dev_display <- dev.cur()
        par(oma=c(1,1,1,1))  # set outer margins
        zones <- matrix(c(2,1), ncol=1, byrow=TRUE)  # numbers in matrix give order of plotting
        layout(zones, widths=c(1,1), heights=c(1/3,2/3))  
      } else if (do_plot) {
        quartz(title=paste0("HZAM; pref_ratio=", pref_ratio,"; hybrid_fitness=", hybrid_fitness, sep=""), width=6, height=5, bg="white")
        dev_display <- dev.cur()
      }
      
      time_vs_width = NULL
      
      # Run cycles of mate choice, reproduction, dispersal
      
      for (time in 1:max_generations) {
        print(time)
        
        # New way of calculating density dependence, using same method as Irwin 2002 AmNat:
        ind_locations_real <- c(pop_matrix_F[,1] , pop_matrix_M[,1])
        get_density_real <- function(focal_location) {
          return(sum(exp(-((ind_locations_real - focal_location)^2)/(2*(sigma_comp^2)))))
        } 
        real_densities_at_spaced_locations <- sapply(spaced_locations, get_density_real)
        # Liou&Price equation, where density dependence based on same K everywhere, but limited growth rate:
        local_growth_rates <- growth_rate*ideal_densities_at_spaced_locations / (ideal_densities_at_spaced_locations + ((real_densities_at_spaced_locations)*(growth_rate - 1)))
        
        # determine male traits (for all males):
        if (mating_trait_loci_dominant == T) {  # the dominant case
          fraction_trait_loci_dominant <- function(x) {
            dominant_count <- 0
            # cycle through trait loci and count up the number of loci with a dominant (="1") allele
            for (locus_count in 1:male_trait_loci) {
              locus_columns <- (2*(locus_count-1))+(MTL_col_start:((MTL_col_start)+1))
              if (sum(x[locus_columns]) %in% c(1,2)) {
                dominant_count <- dominant_count + 1
              }
            }
            return(dominant_count / male_trait_loci)  
          } 
          male_traits <- apply(pop_matrix_M, 1, fraction_trait_loci_dominant) # the dominant case
        } else {
          male_traits <- apply(pop_matrix_M, 1, function(x) mean(x[MTL_col_start:MTL_col_end]))  # the additive case
        }
        
        # determine female preferences (for all females):
        if (mating_trait_loci_dominant == T) {  # the dominant case
          fraction_trait_loci_dominant <- function(x) {
            dominant_count <- 0
            # cycle through trait loci and count up the number of loci with a dominant (="1") allele
            for (locus_count in 1:female_trait_loci) {
              locus_columns <- (2*(locus_count-1))+(FTL_col_start:((FTL_col_start)+1))
              if (sum(x[locus_columns]) %in% c(1,2)) {
                dominant_count <- dominant_count + 1
              }
            }
            return(dominant_count / female_trait_loci)  
          } 
          female_traits <- apply(pop_matrix_F, 1, fraction_trait_loci_dominant) # the dominant case
        } else {
          female_traits <- apply(pop_matrix_F, 1, function(x) mean(x[FTL_col_start:FTL_col_end]))  # the additive case
        }
        
        # cycle through the mothers, determining numbers of offspring
        daughters_per_mother_list <- vector("list", nrow(pop_matrix_F)) # pop_matrix_daughters <- matrix(nrow=0, ncol=1+2*total_loci)
        sons_per_mother_list <- vector("list", nrow(pop_matrix_F)) # pop_matrix_sons <- matrix(nrow=0, ncol=1+2*total_loci)
        # now cycle through all females and determine male mate, reproduction, and daughter genotypes and locations
        for (mother in 1:nrow(pop_matrix_F))  {
          # Find a male mate
          # rank males in terms of distance from female
          male_dists <- abs(pop_matrix_F[mother,1] - pop_matrix_M[,1])  # calculates vector of dist of each male from focal female
          # pick closest male, determine his male signalling trait
          mate <- 0
          rejects <- 0
          while (mate == 0) {
            focal_male <- which(male_dists == min(male_dists))  # returns row number of male that is closest
            
            # compare male trait with female's trait (preference), and determine
            # whether she accepts; note that match_strength is determined by a
            # Gaussian, with a maximum of 1 and minimum of zero.
            match_strength <- (exp(1) ^ ((-(male_traits[focal_male] - female_traits[mother])^2) / (2 * (pref_SD ^2))))
            
            if (runif(1) < match_strength) {
              # she accepts male, and they reproduce
              father <- focal_male
              mate <- 1
            } else {
              # she rejects male
              # change that male's distance to a very large number (99) so he
              # won't be considered again (just in this bit)
              male_dists[focal_male] <- 99
              rejects <- rejects + 1  # count number of rejects, for imposition of fitness cost for search time
            }
          }
          
          # Reproduce
          
          # determine fitness cost due to mate search time
          search_fitness <- (1-per_reject_cost) ^ rejects    # calculate proportion fitness lost (1-cost) due to mate search time
          
          # determine local growth rate at mother's location:
          location_rounded <- round(pop_matrix_F[mother,1], digits=3)
          local_growth <- local_growth_rates[spaced_locations==location_rounded]
          
          #combine for total fitness:   
          
          reproductive_fitness <- 2*local_growth * search_fitness  # the 2 is because only females, not males, produce offspring
          # now draw the number of offspring from a poisson distribution with a mean of total_fitness
          offspring <- rpois(1, reproductive_fitness) 
          daughters <- matrix(nrow=0, ncol=1+2*total_loci)
          sons <- matrix(nrow=0, ncol=1+2*total_loci)
          if (offspring >= 1)  { # if offspring, generate their location and genotypes
            for (kid in 1:offspring) {
              kid_info <- rep(-9, 1+2*total_loci)
              # determine sex of kid (moved this up from lower down and assigned it a variable)
              if (runif(1) > 0.5) {
                kidsex <- "female" 
                while (1 == 1)  {	# disperse the kid #newloc <- pop_matrix_F[mother,1] + rnorm(1, mean=0, sd=meandispersal) <- this was the original script. I modified it to draw from a the log normal distribution.
                  newloc <- pop_matrix_F[mother,1] + rlnorm(n=1, meanlog_F, sdlog_F) * (sample(c(1,-1), size =1))
                  if ((newloc <= range_limit_right) & (newloc >= range_limit_left))  {
                    break
                  }
                }
                kid_info[1] <- newloc } else {
                  kidsex <- "male" 
                  while (1 == 1)  {	# disperse the kid #newloc <- pop_matrix_F[mother,1] + rnorm(1, mean=0, sd=meandispersal) <- this was the original script. I modified it to draw from a the log normal distribution.
                    newloc <- pop_matrix_F[mother,1] + rlnorm(n=1, meanlog_M, sdlog_M) * (sample(c(1,-1), size =1))
                    if ((newloc <= range_limit_right) & (newloc >= range_limit_left))  {
                      break
                    }
                  }
                  kid_info[1] <- newloc 
                }
              # generate genotypes; for each locus, first column for allele from mother, second for allele from father
              for (locus in 1:total_loci) {   
                # choose allele from mother
                kid_info[2+2*(locus-1)] <- pop_matrix_F[mother,1+2*(locus-1)+sample(2, 1)]
                # instead of choosing allele from father, choose again from mother
                # choose allele from father
                kid_info[3+2*(locus-1)] <- pop_matrix_M[father,1+2*(locus-1)+sample(2, 1)]
              }
              # determine sex of kid and add to table
              if (kidsex == "female") {
                daughters <- rbind(daughters, kid_info)
                # pop_matrix_daughters <- rbind(pop_matrix_daughters, kid_info) 
              } else {
                sons <- rbind(sons, kid_info)
                # pop_matrix_sons <- rbind(pop_matrix_sons, kid_info)
              }
            } 
          } 
          daughters_per_mother_list[[mother]] <- daughters
          sons_per_mother_list[[mother]] <- sons
        } 
        pop_matrix_daughters <- do.call("rbind", daughters_per_mother_list)
        pop_matrix_sons <- do.call("rbind", sons_per_mother_list)
        
        # determine fitnesses of daughters due to heterozygosity at (option 1) heterozygosity, or (option 2) epistasis 
        if (survival_fitness_method == 1) {
          underdominance_fitness_daughters <- rep(NaN, dim(pop_matrix_daughters)[1])
          for (daughter in 1:nrow(pop_matrix_daughters))  {
            heterozyg_loci <- 0
            for (locus in 1:underdominant_loci) {
              locus_col <- UDL_col_start + 2*(locus-1)
              if (mean(pop_matrix_daughters[daughter,locus_col:(locus_col+1)]) == 0.5 ) { 
                heterozyg_loci <- heterozyg_loci + 1
              }
            }
            underdominance_fitness_daughters[daughter] <- (1-s_per_locus) ^ heterozyg_loci
          }
          # determine whether each daughter survives to adulthood
          random_proportions_daughters <- runif(n=length(underdominance_fitness_daughters), min=0, max=1)
          daughters_survive <- underdominance_fitness_daughters > random_proportions_daughters
          
          # determine fitnesses of sons due to heterozygosity at underdominance loci
          underdominance_fitness_sons <- rep(NaN, dim(pop_matrix_sons)[1])
          for (son in 1:nrow(pop_matrix_sons))  {
            heterozyg_loci <- 0
            for (locus in 1:underdominant_loci) {
              locus_col <- UDL_col_start + 2*(locus-1)
              if (mean(pop_matrix_sons[son,locus_col:(locus_col+1)]) == 0.5 ) { 
                heterozyg_loci <- heterozyg_loci + 1
              }
            }
            underdominance_fitness_sons[son] <- (1-s_per_locus) ^ heterozyg_loci
          } 
          # determine whether each son survives to adulthood
          random_proportions_sons <- runif(n=length(underdominance_fitness_sons), min=0, max=1)
          sons_survive <- underdominance_fitness_sons > random_proportions_sons
          
        } else if (survival_fitness_method == 2) {
          HI_daughters <- rowMeans(pop_matrix_daughters[,UDL_col_start:UDL_col_end]) # apply(pop_matrix_daughters, 1, function(x) mean(x[UDL_col_start:UDL_col_end]))
          epistasis_fitness_daughters <- 1 - (1-hybrid_fitness) * (4*HI_daughters*(1-HI_daughters))^beta
          random_proportions_daughters <- runif(n=length(epistasis_fitness_daughters), min=0, max=1)
          daughters_survive <- epistasis_fitness_daughters > random_proportions_daughters
          
          HI_sons <- rowMeans(pop_matrix_sons[,UDL_col_start:UDL_col_end])  # apply(pop_matrix_sons, 1, function(x) mean(x[UDL_col_start:UDL_col_end]))
          epistasis_fitness_sons <- 1 - (1-hybrid_fitness) * (4*HI_sons*(1-HI_sons))^beta
          random_proportions_sons <- runif(n=length(epistasis_fitness_sons), min=0, max=1)
          sons_survive <- epistasis_fitness_sons > random_proportions_sons  
        }
        
        # assign surviving offspring to new adult population
        pop_matrix_F <- pop_matrix_daughters[daughters_survive,]
        pop_matrix_M <- pop_matrix_sons[sons_survive,]
        
        
        # option of fitting cline during the simulation
        if (fit_to_cline_during & ((time %% plot_int) == 0)) {
          # choose the data to include
          
          x = c(pop_matrix_F[,1] , pop_matrix_M[,1])
          if (cline=="UDL") {
            y = c(rowMeans(pop_matrix_F[,UDL_col_start:UDL_col_end]) , rowMeans(pop_matrix_M[,UDL_col_start:UDL_col_end]))
          }
          else if (cline=="MTL") {
            y = c(rowMeans(pop_matrix_F[,MTL_col_start:MTL_col_end]) , rowMeans(pop_matrix_M[,MTL_col_start:MTL_col_end]))
          }
          else if (cline=="UDL and NL") {
            y = c(rowMeans(pop_matrix_F[,UDL_col_start:UDL_col_end]) , rowMeans(pop_matrix_M[,UDL_col_start:UDL_col_end]))
            y_NL = c(rowMeans(pop_matrix_F[,NL_col_start:NL_col_end]) , rowMeans(pop_matrix_M[,NL_col_start:NL_col_end]))
          }
          
          # fit UDL or MTL to cline
          mydata <- as.data.frame(cbind(x,y))
          z <- gam(y ~ s(x), data=  mydata, quasibinomial(link = "logit"),
                   method = "ML")
          x.spaced <- seq(0, 1, by=0.001)
          y.predicted <- inv.logit(as.vector(predict.gam(z, newdata=data.frame(x=x.spaced))))
          #thanks to Dolph Schluter for his help with above                      
          
          if (width_method=="tangent") {
            #find the x with maximum slope
            first.diff <- diff(y.predicted)
            index <- which.max(first.diff)
            x.1 <- x.spaced[index]
            x.2 <- x.spaced[index+1]
            y.1 <- y.predicted[index]
            y.2 <- y.predicted[index+1]
            max.slope <- (y.2 - y.1) / (x.2 - x.1)
            width <- 1/max.slope   # if asymptotes at 0 and 1
            print(paste0("width = ",round(width, digits=3)))
            intercept <- y.1 - max.slope*x.1
            X.high <- (1 - intercept) / max.slope
            X.low <- (0 - intercept) / max.slope
            
          }
          
          if (width_method=="eightieth") {
            # find place that fit goes below 0.05 on left of center
            left_width_margin <- max(x.spaced[y.predicted <= 0.1])
            # find place where fit goes above 0.95 on right of center
            right_width_margin <- min(x.spaced[y.predicted >= 0.9])
            dist_from_HI50percent <- abs(y.predicted-0.5)
            centre <- x.spaced[dist_from_HI50percent == min(dist_from_HI50percent)]
            width <- right_width_margin - left_width_margin
            print(paste0("width = ",round(width, digits=3)))
          }
          
          # this part is for the NL clinefit and width
          if (cline=="UDL and NL") {     
            mydata <- as.data.frame(cbind(x,y_NL))
            z <- gam(y_NL ~ s(x), data=  mydata, quasibinomial(link = "logit"),
                     method = "ML")
            NL.x.spaced <- seq(0, 1, by=0.001)
            NL.y.predicted <- inv.logit(as.vector(predict.gam(z, newdata=data.frame(x=x.spaced))))
            #thanks to Dolph Schluter for his help with above                      
            
            if (width_method=="tangent") {
              #find the x with maximum slope
              first.diff <- diff(NL.y.predicted)
              index <- which.max(first.diff)
              x.1 <- NL.x.spaced[index]
              x.2 <- NL.x.spaced[index+1]
              y.1 <- NL.y.predicted[index]
              y.2 <- NL.y.predicted[index+1]
              max.slope <- (y.2 - y.1) / (x.2 - x.1)
              width_NL <- 1/max.slope   # if asymptotes at 0 and 1
              print(paste0("width_NL = ",round(width_NL, digits=3)))
              intercept <- y.1 - max.slope*x.1
              NL.X.high <- (1 - intercept) / max.slope
              NL.X.low <- (0 - intercept) / max.slope
            }
            
            if (width_method=="eightieth") {
              # find place that fit goes below 0.05 on left of center
              NL.left_width_margin <- max(NL.x.spaced[NL.y.predicted <= 0.1])
              # find place where fit goes above 0.95 on right of center
              NL.right_width_margin <- min(NL.x.spaced[NL.y.predicted >= 0.9])
              dist_from_HI50percent <- abs(NL.y.predicted-0.5)
              NL.centre <- x.spaced[dist_from_HI50percent == min(dist_from_HI50percent)]
              width_NL <- NL.right_width_margin - NL.left_width_margin
              print(paste0("width_NL = ",round(width_NL, digits=3)))
            }
          }
          
          # add time and width to matrix
          if (cline=="UDL" | cline =="MTL") {
            time_vs_width <- rbind(time_vs_width, c(time, width, centre, left_width_margin, right_width_margin))
          } else if (cline=="UDL and NL") {
            time_vs_width <- rbind(time_vs_width, c(time, width, width_NL, centre, NL.centre, left_width_margin, NL.left_width_margin, right_width_margin, NL.right_width_margin))
          }
        }
        
        if (do_plot == 1) {
          if ((time %% plot_int) == 0)  { # update figures at regular intervals (x%%y means remainder of x/y)    
            if (plot_density) {
              par(mar=c(3,3,1,1))  # specifies number of lines around plot (bottom, left, top right)
            }
            
            plot(x=NULL, y=NULL, xlim=c(0,1), ylim=c(-0.05,1.05), yaxp=c(0,1,5), cex.axis=0.8, tcl=-0.5, xlab=NA, ylab=NA, mgp=c(3,0.5,0))
            
            if (fit_to_cline_during) {
              if (width_method=="tangent") {
                # add fit to plot
                lines(c(X.high, X.low), c(1, 0), col=adjustcolor("grey", alpha.f = 0.5), lwd=4)
                #lines(x.spaced, y.predicted, col=adjustcolor("blue", alpha.f = 0.75), lwd=4)
              }
              
              if (width_method=="eightieth") {
                polygon(x=c(left_width_margin, right_width_margin, right_width_margin, left_width_margin), y=c(-0.05, -0.05, 1.05, 1.05), col=adjustcolor("skyblue", alpha.f = 0.5), border=NA)
                #lines(x.spaced, y.predicted, col=adjustcolor("blue", alpha.f = 0.75), lwd=4)
              }
              
              if (cline=="UDL and NL") {
                if (width_method=="tangent") {
                  # add fit to plot
                  lines(c(NL.X.high, NL.X.low), c(1, 0), col=adjustcolor("grey70", alpha.f = 0.5), lwd=4)
                  lines(NL.x.spaced, NL.y.predicted, col=adjustcolor("grey30", alpha.f = 0.75), lwd=4)
                }
                
                if (width_method=="eightieth") {
                  # add fit to plot
                  polygon(x=c(NL.left_width_margin, NL.right_width_margin, NL.right_width_margin, NL.left_width_margin), y=c(-0.05, -0.05, 1.05, 1.05), col=adjustcolor("grey70", alpha.f = 0.5), border=NA)
                  lines(NL.x.spaced, NL.y.predicted, col=adjustcolor("grey30", alpha.f = 0.75), lwd=4)
                }
              }
            }
            
            if (plot_NL) {
              # graph hybrid index based on NL loci
              x_M = pop_matrix_M[,1]
              y_M = rowMeans(pop_matrix_M[,NL_col_start:NL_col_end])
              colour <- adjustcolor(NL_colour, alpha.f = 0.5)
              points(x_M, jitter(y_M, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
              x_F = pop_matrix_F[,1]
              y_F = rowMeans(pop_matrix_F[,NL_col_start:NL_col_end])
              colour <- adjustcolor(NL_colour, alpha.f = 0.5)
              points(x_F, jitter(y_F, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
            }
            
            if (plot_UDL) {
              # graph hybrid index based on UDL loci
              x_M = pop_matrix_M[,1]
              y_M = rowMeans(pop_matrix_M[,UDL_col_start:UDL_col_end])
              colour <- adjustcolor(UDL_colour, alpha.f = 0.5)
              points(x_M, jitter(y_M, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
              x_F = pop_matrix_F[,1]
              y_F = rowMeans(pop_matrix_F[,UDL_col_start:UDL_col_end])
              colour <- adjustcolor(UDL_colour, alpha.f = 0.5)
              points(x_F, jitter(y_F, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
            }
            
            if (plot_MTL) {
              # graph hybrid index based on MTL loci
              x_M = pop_matrix_M[,1]
              y_M = rowMeans(pop_matrix_M[,MTL_col_start:MTL_col_end])
              colour <- adjustcolor(MTL_colour, alpha.f = 0.5)
              points(x_M, jitter(y_M, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
              x_F = pop_matrix_F[,1]
              y_F = rowMeans(pop_matrix_F[,MTL_col_start:MTL_col_end])
              colour <- adjustcolor(MTL_colour, alpha.f = 0.5)
              points(x_F, jitter(y_F, amount=0.015), col=colour, bg=colour, pch=16, cex=0.6)
            }
            
            mtext(text=paste0("generation ",time), side=3, line=0.5, adj=0)
            title(xlab="Location", line=2, cex.lab=1.2)
            title(ylab="Hybrid index", line=2, cex.lab=1.2)
            
            if (plot_density) {
              # graph density
              par(mar=c(1,3,1,1))  # specifies number of lines around plot (bottom, left, top right)
              F_hist <- hist(x_F, breaks=seq(0, 1, by=1/demes), plot=FALSE)
              M_hist <- hist(x_M, breaks=seq(0, 1, by=1/demes), plot=FALSE)
              barplot(F_hist$counts + M_hist$counts, space=0, cex.axis=0.8, tcl=-0.5, xlab=NA, ylab=NA, mgp=c(3,0.5,0))
              title(ylab="Density ", line=2, cex.lab=1.2)
            }
            
            if (make_movie & (time %in% movie_gen)) {
              main_dev_number <- dev.cur()
              digit <- NULL
              if (time < 10) {
                digit <- "000"
              } else if (time < 100) {
                digit <- "00"
              } else if (time < 1000) {
                digit <- "0"
              }
              dev.copy(png, width = 6, height = 5, units = "in", res=200, filename=paste0("new_movie/",movie_name,digit,time,".png"))  # copies plot to png file
              dev.off()
              dev.set(main_dev_number)  # returns to main quartz screen
            }
          }
        }           
      }    
      
      pop_matrix_F <- cbind(pop_matrix_F, rep(i, nrow(pop_matrix_F)))
      pop_matrix_M <- cbind(pop_matrix_M, rep(i, nrow(pop_matrix_M)))
      
      # assign surviving offspring to new adult population
      Big_matrix_F <- rbind(Big_matrix_F, pop_matrix_F)
      Big_matrix_M <- rbind(Big_matrix_M, pop_matrix_M)
      
    }
  }
}        

#############################################
#############################################

#Merge Males nd Female Matrices ONLY for the MtDNA and Nuclear DNA (for the Y chromosome only work with the Males)
Big_matrix_both <- rbind(Big_matrix_F, Big_matrix_M)

SumNative <- rowSums(Big_matrix_both==0)/nrow(Big_matrix_both)

#Then convert it to a dataframe
Big_DF_both <- as.data.frame(Big_matrix_both)
colnames(Big_DF_both) <- c("Location")

##make a summary for allele frequencies of each population
Big_DF_both$Pop1 <- (rowSums(Big_DF_both == 0))/200
Big_DF_both$Pop2 <- (1 - Big_DF_both$Pop1)

### Need to add a new column to the matrix that assigns a location bin to the data ###
Big_DF_both$LocSummary <- findInterval(Big_DF_both$Location, c(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1), rightmost.closed = TRUE)  

##quick plot
#plot(Big_DF_both$LocSummary, Big_DF_both$Pop2)

##Calculate the mean and Standard Error of each bin

##Make a list of the LocSummaries note these are not characters right now...
LocIDs <- Big_DF_both$LocSummary

p <- Big_DF_both$Pop2

#Read in distances of "sampling locations"
d <- read.csv("HZAM_HZAR_location_distances.csv", header=T, stringsAsFactors=F)

## Output vector of distances
d$distance -> dists

## Get population means
sapply(unique(LocIDs),function(x){mean(p[which(LocIDs %in% x)])},USE.NAMES=F) %>% round(4) -> means
means

## Get population variances
sapply(unique(LocIDs),function(x){var(p[which(LocIDs %in% x)])},USE.NAMES=F) -> vars

## Get population counts
sapply(unique(LocIDs),function(x){length(p[which(LocIDs %in% x)])},USE.NAMES=F) -> counts

## Create data frame for input into Hzar
data.frame(LocIDs=unique(LocIDs),dists,means,vars,counts) -> m

m

##write the data to a .csv file
write.csv(m, file = run_set_name)

#plot(m$LocIDs,m$means)
library(ggplot2)

p <- ggplot(m, aes(x=LocIDs, y=means, ymin=0, ymax=1)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=means-vars, ymax=means+vars))

#ggsave("NuDNA_100loci_SBD_44.9_7.84_18gens_NewHZBorder_20230330_150sims.pdf", plot = p, width = 5, height = 5)
#############################################
#############################################
#############################################
#############################################
