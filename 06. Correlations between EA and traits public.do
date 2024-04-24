********************************
** by: Francisca Ibacache
** date: 21/09/2022
********************************

* Analysis – Correlations between EA variables and other characteristics

*** Pearson's Correlations
use "/PATH/TO/FILE/PrecisionPaper_cohort and EAV_clean.dta", clear


pwcorr TEI WC BMI ODP Grams_mean_AT EnergyKcal_mean_AT TimeFirst_mean_AT TimeLast_mean_AT EatingPeriod_mean_AT InterMealInterval_mean_AT n_occasions_mean_AT Grams_mean_MS EnergyKcal_mean_MS TimeFirst_mean_MS TimeLast_mean_MS EatingPeriod_mean_MS InterMealInterval_mean_MS n_occasions_mean_MS, sig /* correlations between EAV and other vars with pvalue */

*getting confidence intervals for the correlations using ci2
ssc install ci2
ci2 TEI Grams_mean_AT, corr
ci2 TEI EnergyKcal_mean_AT, corr
ci2 TEI TimeFirst_mean_AT, corr
ci2 TEI TimeLast_mean_AT, corr
ci2 TEI EatingPeriod_mean_AT, corr
ci2 TEI InterMealInterval_mean_AT, corr
ci2 TEI n_occasions_mean_AT, corr
ci2 TEI Grams_mean_MS, corr
ci2 TEI EnergyKcal_mean_MS, corr
ci2 TEI TimeFirst_mean_MS, corr
ci2 TEI TimeLast_mean_MS, corr
ci2 TEI EatingPeriod_mean_MS, corr
ci2 TEI InterMealInterval_mean_MS, corr
ci2 TEI n_occasions_mean_MS, corr

ci2 WC Grams_mean_AT, corr
ci2 WC EnergyKcal_mean_AT, corr
ci2 WC TimeFirst_mean_AT, corr
ci2 WC TimeLast_mean_AT, corr
ci2 WC EatingPeriod_mean_AT, corr
ci2 WC InterMealInterval_mean_AT, corr
ci2 WC n_occasions_mean_AT, corr
ci2 WC Grams_mean_MS, corr
ci2 WC EnergyKcal_mean_MS, corr
ci2 WC TimeFirst_mean_MS, corr
ci2 WC TimeLast_mean_MS, corr
ci2 WC EatingPeriod_mean_MS, corr
ci2 WC InterMealInterval_mean_MS, corr
ci2 WC n_occasions_mean_MS, corr

ci2 BMI Grams_mean_AT, corr
ci2 BMI EnergyKcal_mean_AT, corr
ci2 BMI TimeFirst_mean_AT, corr
ci2 BMI TimeLast_mean_AT, corr
ci2 BMI EatingPeriod_mean_AT, corr
ci2 BMI InterMealInterval_mean_AT, corr
ci2 BMI n_occasions_mean_AT, corr
ci2 BMI Grams_mean_MS, corr
ci2 BMI EnergyKcal_mean_MS, corr
ci2 BMI TimeFirst_mean_MS, corr
ci2 BMI TimeLast_mean_MS, corr
ci2 BMI EatingPeriod_mean_MS, corr
ci2 BMI InterMealInterval_mean_MS, corr
ci2 BMI n_occasions_mean_MS, corr

ci2 ODP Grams_mean_AT, corr
ci2 ODP EnergyKcal_mean_AT, corr
ci2 ODP TimeFirst_mean_AT, corr
ci2 ODP TimeLast_mean_AT, corr
ci2 ODP EatingPeriod_mean_AT, corr
ci2 ODP InterMealInterval_mean_AT, corr
ci2 ODP n_occasions_mean_AT, corr
ci2 ODP Grams_mean_MS, corr
ci2 ODP EnergyKcal_mean_MS, corr
ci2 ODP TimeFirst_mean_MS, corr
ci2 ODP TimeLast_mean_MS, corr
ci2 ODP EatingPeriod_mean_MS, corr
ci2 ODP InterMealInterval_mean_MS, corr
ci2 ODP n_occasions_mean_MS, corr




