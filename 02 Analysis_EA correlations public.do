********************************
** by: Francisca Ibacache
** date: 22/03/2022
********************************



* Analysis – Correlations between EA variables

*** CORRELATIONS

use "/PATH/TO/FILE/Eating Architecture MS vs AT 7y.dta", clear

pwcorr Grams_mean_AT EnergyKcal_mean_AT TimeFirst_mean_AT TimeLast_mean_AT EatingPeriod_mean_AT InterMealInterval_mean_AT n_occasions_mean_AT Grams_mean_MS EnergyKcal_mean_MS TimeFirst_mean_MS TimeLast_mean_MS EatingPeriod_mean_MS InterMealInterval_mean_MS n_occasions_mean_MS, sig /* correlations between EAV with pvalue */

* +confidence intervals for the correlations using ci2
*ssc install ci2

ci2 Grams_mean_AT EnergyKcal_mean_AT, corr 
ci2 Grams_mean_AT TimeFirst_mean_AT , corr
ci2 Grams_mean_AT TimeLast_mean_AT , corr
ci2 Grams_mean_AT EatingPeriod_mean_AT, corr 
ci2 Grams_mean_AT InterMealInterval_mean_AT, corr 
ci2 Grams_mean_AT n_occasions_mean_AT , corr
ci2 Grams_mean_AT Grams_mean_MS , corr
ci2 Grams_mean_AT EnergyKcal_mean_MS , corr
ci2 Grams_mean_AT TimeFirst_mean_MS , corr
ci2 Grams_mean_AT TimeLast_mean_MS , corr
ci2 Grams_mean_AT EatingPeriod_mean_MS , corr
ci2 Grams_mean_AT InterMealInterval_mean_MS, corr 
ci2 Grams_mean_AT n_occasions_mean_MS, corr

ci2 EnergyKcal_mean_AT TimeFirst_mean_AT , corr
ci2 EnergyKcal_mean_AT TimeLast_mean_AT , corr
ci2 EnergyKcal_mean_AT EatingPeriod_mean_AT, corr 
ci2 EnergyKcal_mean_AT InterMealInterval_mean_AT, corr 
ci2 EnergyKcal_mean_AT n_occasions_mean_AT , corr
ci2 EnergyKcal_mean_AT Grams_mean_MS , corr
ci2 EnergyKcal_mean_AT EnergyKcal_mean_MS , corr
ci2 EnergyKcal_mean_AT TimeFirst_mean_MS , corr
ci2 EnergyKcal_mean_AT TimeLast_mean_MS , corr
ci2 EnergyKcal_mean_AT EatingPeriod_mean_MS , corr
ci2 EnergyKcal_mean_AT InterMealInterval_mean_MS, corr 
ci2 EnergyKcal_mean_AT n_occasions_mean_MS, corr


ci2 TimeFirst_mean_AT TimeLast_mean_AT, corr 
ci2 TimeFirst_mean_AT EatingPeriod_mean_AT, corr 
ci2 TimeFirst_mean_AT InterMealInterval_mean_AT, corr 
ci2 TimeFirst_mean_AT n_occasions_mean_AT , corr
ci2 TimeFirst_mean_AT Grams_mean_MS , corr
ci2 TimeFirst_mean_AT EnergyKcal_mean_MS , corr
ci2 TimeFirst_mean_AT TimeFirst_mean_MS , corr
ci2 TimeFirst_mean_AT TimeLast_mean_MS , corr
ci2 TimeFirst_mean_AT EatingPeriod_mean_MS , corr
ci2 TimeFirst_mean_AT InterMealInterval_mean_MS, corr 
ci2 TimeFirst_mean_AT n_occasions_mean_MS, corr


ci2 TimeLast_mean_AT EatingPeriod_mean_AT, corr 
ci2 TimeLast_mean_AT InterMealInterval_mean_AT, corr 
ci2 TimeLast_mean_AT n_occasions_mean_AT , corr
ci2 TimeLast_mean_AT Grams_mean_MS , corr
ci2 TimeLast_mean_AT EnergyKcal_mean_MS , corr
ci2 TimeLast_mean_AT TimeFirst_mean_MS , corr
ci2 TimeLast_mean_AT TimeLast_mean_MS , corr
ci2 TimeLast_mean_AT EatingPeriod_mean_MS , corr
ci2 TimeLast_mean_AT InterMealInterval_mean_MS, corr 
ci2 TimeLast_mean_AT n_occasions_mean_MS, corr


ci2 EatingPeriod_mean_AT InterMealInterval_mean_AT, corr 
ci2 EatingPeriod_mean_AT n_occasions_mean_AT , corr
ci2 EatingPeriod_mean_AT Grams_mean_MS , corr
ci2 EatingPeriod_mean_AT EnergyKcal_mean_MS , corr
ci2 EatingPeriod_mean_AT TimeFirst_mean_MS , corr
ci2 EatingPeriod_mean_AT TimeLast_mean_MS , corr
ci2 EatingPeriod_mean_AT EatingPeriod_mean_MS , corr
ci2 EatingPeriod_mean_AT InterMealInterval_mean_MS, corr 
ci2 EatingPeriod_mean_AT n_occasions_mean_MS, corr


ci2 InterMealInterval_mean_AT n_occasions_mean_AT , corr
ci2 InterMealInterval_mean_AT Grams_mean_MS , corr
ci2 InterMealInterval_mean_AT EnergyKcal_mean_MS , corr
ci2 InterMealInterval_mean_AT TimeFirst_mean_MS , corr
ci2 InterMealInterval_mean_AT TimeLast_mean_MS , corr
ci2 InterMealInterval_mean_AT EatingPeriod_mean_MS , corr
ci2 InterMealInterval_mean_AT InterMealInterval_mean_MS, corr 
ci2 InterMealInterval_mean_AT n_occasions_mean_MS, corr


ci2 n_occasions_mean_AT Grams_mean_MS , corr
ci2 n_occasions_mean_AT EnergyKcal_mean_MS , corr
ci2 n_occasions_mean_AT TimeFirst_mean_MS , corr
ci2 n_occasions_mean_AT TimeLast_mean_MS , corr
ci2 n_occasions_mean_AT EatingPeriod_mean_MS , corr
ci2 n_occasions_mean_AT InterMealInterval_mean_MS, corr 
ci2 n_occasions_mean_AT n_occasions_mean_MS, corr


ci2 Grams_mean_MS EnergyKcal_mean_MS , corr
ci2 Grams_mean_MS TimeFirst_mean_MS , corr
ci2 Grams_mean_MS TimeLast_mean_MS , corr
ci2 Grams_mean_MS EatingPeriod_mean_MS , corr
ci2 Grams_mean_MS InterMealInterval_mean_MS, corr 
ci2 Grams_mean_MS n_occasions_mean_MS, corr


ci2 EnergyKcal_mean_MS TimeFirst_mean_MS , corr
ci2 EnergyKcal_mean_MS TimeLast_mean_MS , corr
ci2 EnergyKcal_mean_MS EatingPeriod_mean_MS , corr
ci2 EnergyKcal_mean_MS InterMealInterval_mean_MS, corr 
ci2 EnergyKcal_mean_MS n_occasions_mean_MS, corr


ci2 TimeFirst_mean_MS TimeLast_mean_MS , corr
ci2 TimeFirst_mean_MS EatingPeriod_mean_MS , corr
ci2 TimeFirst_mean_MS InterMealInterval_mean_MS, corr 
ci2 TimeFirst_mean_MS n_occasions_mean_MS, corr


ci2 TimeLast_mean_MS EatingPeriod_mean_MS , corr
ci2 TimeLast_mean_MS InterMealInterval_mean_MS, corr 
ci2 TimeLast_mean_MS n_occasions_mean_MS, corr


ci2 EatingPeriod_mean_MS InterMealInterval_mean_MS, corr 
ci2 EatingPeriod_mean_MS n_occasions_mean_MS, corr


ci2 InterMealInterval_mean_MS n_occasions_mean_MS, corr


