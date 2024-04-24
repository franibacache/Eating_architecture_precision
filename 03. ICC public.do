********************************
** by: Francisca Ibacache
** date: 15/08/2023
********************************

* Analysis – Intraclass correlation coefficients (ICC)

* ICC Calculation in Stata Using Single-Rating, Absolute-Agreement, 2-Way Random-Effects Model
* Use dataset with complete data for the precision paper analysis, but extracting just EA vars, sex and id, then convert from wide to long format and perform ICC analysis


use aln qlet sex Grams_mean_AT EnergyKcal_mean_AT TimeFirst_mean_AT TimeLast_mean_AT EatingPeriod_mean_AT InterMealInterval_mean_AT n_occasions_mean_AT Grams_mean_MS EnergyKcal_mean_MS TimeFirst_mean_MS TimeLast_mean_MS EatingPeriod_mean_MS InterMealInterval_mean_MS n_occasions_mean_MS using "/PATH/TO/FILE/PrecisionPaper_cohort and EAV_clean.dta" if Grams_mean_AT !=.

egen id = concat(aln qlet)
order id aln qlet sex
 
rename Grams_mean_AT GramsAT
rename EnergyKcal_mean_AT KcalAT
rename TimeFirst_mean_AT TimeFirstAT
rename TimeLast_mean_AT TimeLastAT
rename EatingPeriod_mean_AT PeriodAT
rename InterMealInterval_mean_AT IntervalAT
rename n_occasions_mean_AT FreqAT
rename Grams_mean_MS GramsMS
rename EnergyKcal_mean_MS KcalMS
rename TimeFirst_mean_MS TimeFirstMS
rename TimeLast_mean_MS TimeLastMS
rename EatingPeriod_mean_MS PeriodMS
rename InterMealInterval_mean_MS IntervalMS
rename n_occasions_mean_MS FreqMS

            
reshape long Grams@ Kcal@ TimeFirst@ TimeLast@ Period@ Interval@ Freq@, i(id) j(Precision) string
 

 
*Two-way random effects ICCs

icc Grams id Precision
icc Grams id Precision, mixed
icc Grams id Precision, mixed absolute 
icc Kcal id Precision
icc Kcal id Precision, mixed
icc Kcal id Precision, mixed absolute
icc TimeFirst id Precision
icc TimeFirst id Precision, mixed
icc TimeFirst id Precision, mixed absolute
icc TimeLast id Precision
icc TimeLast id Precision, mixed
icc TimeLast id Precision, mixed absolute
icc Period id Precision
icc Period id Precision, mixed
icc Period id Precision, mixed absolute
icc Interval id Precision
icc Interval id Precision, mixed
icc Interval id Precision, mixed absolute
icc Freq id Precision
icc Freq id Precision, mixed
icc Freq id Precision, mixed absolute


save "/PATH/TO/FILE/PrecisionPaper_ICC.dta", replace 
