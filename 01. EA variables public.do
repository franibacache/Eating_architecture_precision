********************************
** by: Francisca Ibacache
** date: 22/03/2022
********************************


*****************************************************************************************************************************
*****    ALSPAC F@7 eating architecture variables (EAVs) creation (size, time, and frequency variables).           **********
*****    First, EAVs are generated based on time slots. Then, EAVs were generated based on exact time of intake.   **********
*****************************************************************************************************************************



******                                                                  ******
******              I. Create MS variables (broad)                      ******
******                                                                  ******

***Open file with line per food, time and ALN and QLET for merging with other cohort data 
use "/PATH/TO/FILE/Only complete MS and AT data full_7y.dta", clear


**Recode time allocated to broad meal slot to be the mid-point of the period it refers to**.
replace fa07time = 13.25 if fa07time==13
replace fa07time = 15.75 if fa07time==17
replace fa07time = 18.25 if fa07time==20
replace fa07time = 21.75 if fa07time==22


***STEP 1: Collapse grams and energy on all food items eaten in the same meal slot, create new datafile with one line per eating occasion EO_fa07time.dta***. 
sort aln qlet fa07day fa07time
clonevar fa07timeclone=fa07time
collapse (sum) Grams_MS=fa07fdwt Energy_kcal_MS=fa07kcal Energy_kJ_MS=fa07kj (median) Time_MS=fa07time, by (aln qlet fa07day fa07timeclone) 
label variable Grams_MS "Amount eaten (g) per occasion (based on meal slot)"
label variable Time_MS "Time of eating occasion (based on meal slot)" 
label variable Energy_kcal_MS "Energy intake (kcal) per occasion (based on meal slot)"
label variable Energy_kJ_MS "Energy intake (kJ) per occasion (based on meal slot)"
rename fa07timeclone fa07time
save "/PATH/TO/FILE/EO_fa07timeMS.dta", replace


***STEP 2: Open new eating occasion level file and collapse eating occasion within each day to generate timing and frequency variables per day***.
use "/PATH/TO/FILE/EO_fa07timeMS.dta", clear
sort aln qlet fa07day fa07time

***Compute time in minutes since midnight, to be able to compute total eating period and intermeal intervals using subtraction (and for meaningful description on a continuous decimal scale. Using fa07time, as this already only stores hours since midnight **.
gen mealtime_minutes_MS = fa07time*60
label variable mealtime_minutes_MS "Time of eating occasion in minutes since midnight (based on meal slot)"

***Collapse timing of eating occasions and count frequency of eating occasions in the same day***.
collapse (firstnm) TimeFirst_MS=mealtime_minutes_MS (lastnm) TimeLast_MS=mealtime_minutes_MS (count) n_occasions_MS=fa07time, by (aln qlet fa07day)
label variable TimeFirst_MS "Time of first eating occasion (minutes since midnight) (based on meal slot)"
label variable TimeLast_MS "Time of last eating occasion (minutes since midnight) (based on meal slot)"
label variable n_occasions_MS "Total number of eating occasions (based on meal slots)"
save "/PATH/TO/FILE/aggr.dta", replace


***STEP 3: Open day level file and compute eating period variable, then collapse to person-level averages***.
use "/PATH/TO/FILE/aggr.dta", clear

***Estimate eating period by subtracting the first time of eating from the last time of eating, the is the total time duration over which eating occurs in a day.
gen EatingPeriod_MS=TimeLast_MS-TimeFirst_MS
label variable EatingPeriod_MS "Time duration (minutes) over which eating occasion occur in a day) (based on meal slot)"

***Estimate intermeal intervals 
gen InterMealInterval_MS=EatingPeriod_MS/n_occasions_MS
label variable InterMealInterval_MS "Estimated daily average intermeal interval (minutes) from EatingPeriod/n_occasions (based on meal slot)"

***Collapse to person-level averages
sort aln qlet
collapse (mean) TimeFirst_mean_MS=TimeFirst_MS TimeLast_mean_MS=TimeLast_MS EatingPeriod_mean_MS=EatingPeriod_MS InterMealInterval_mean_MS=InterMealInterval_MS  n_occasions_mean_MS=n_occasions_MS (count) n_days=fa07day, by (aln qlet)

label variable TimeFirst_mean_MS "First time of eating (Mean over 3 days minutes since midnight) (based on meal slot)"
label variable TimeLast_mean_MS "Last time of eating (Mean over 3 days minutes since midnight) (based on meal slot)"
label variable EatingPeriod_mean_MS "Mean eating period (minutes) over 3 days (based on meal slot)"
label variable InterMealInterval_mean_MS "Mean (across 3 days) of estimated daily average intermeal interval (minutes) from EatingPeriod/n_occasions (based on meal slot)"
label variable n_occasions_mean_MS "Mean number of eating occasions (times per day) over 3 days (based on meal slot)"
label variable n_days "Total number of days"

*** Set number of decimals to two
format %9.2f InterMealInterval_mean_MS
format %8.2f n_occasions_mean_MS
format %9.2f EatingPeriod_mean_MS
format %9.2f TimeLast_mean_MS
format %9.2f TimeFirst_mean_MS

save "/PATH/TO/FILE/TEMP.dta", replace


**Open person-level file containing time and frequency variables, save as Eating Architecture file and merge all subsequent variables created into this file.
use "/PATH/TO/FILE/TEMP.dta", clear
sort aln qlet
save "/PATH/TO/FILE/Eating Architecture_aln.dta", replace


***STEP 4: Create eating occasion size variables (means) by opening the eating occasion level file and collapsing energy or grams**.
use "/PATH/TO/FILE/EO_fa07timeMS.dta"
sort aln qlet

**--- before collapsing the means across the 3 days, first collapse the means of grams and kcal per day, which is not done in previous steps
collapse (mean) Grams_ddd_MS=Grams_MS EnergyKcal_ddd_MS=Energy_kcal_MS EnergykJ_ddd_MS=Energy_kJ_MS, by (aln qlet fa07day)
label variable Grams_ddd_MS "Mean amount eaten (g) per eating occasion per diet diary day (based on meal slot)"
label variable EnergyKcal_ddd_MS "Mean Energy intake (kcal) per occasion per diet diary day (based on meal slot)"
label variable EnergykJ_ddd_MS "Mean Energy intake (kJ) per occasion per diet diary day (based on meal slot)"
format %8.2f Grams_ddd_MS
format %8.2f EnergyKcal_ddd_MS
format %8.2f EnergykJ_ddd_MS

*Now collapsing those to generate means of g and kcal per EO averaged across 3 days**
collapse (mean) Grams_mean_MS=Grams_ddd_MS EnergyKcal_mean_MS=EnergyKcal_ddd_MS EnergykJ_mean_MS=EnergykJ_ddd_MS, by (aln qlet)
label variable Grams_mean_MS "Mean amount eaten (g) per eating occasion (based on meal slot)"
label variable EnergyKcal_mean_MS "Mean Energy intake (kcal) per occasion (based on meal slot)"
label variable EnergykJ_mean_MS "Mean Energy intake (kJ) per occasion (based on meal slot)"
format %8.2f Grams_mean_MS
format %8.2f EnergyKcal_mean_MS
format %8.2f EnergykJ_mean_MS


save "/PATH/TO/FILE/aggr.dta", replace


***Merging new average eating occasion size variables to Eating Architecture file***.
use "/PATH/TO/FILE/aggr.dta"
sort aln qlet

merge 1:1 aln qlet using "/PATH/TO/FILE/Eating Architecture_aln.dta", nogen
sort aln qlet



save "/PATH/TO/FILE/EA_MS_7y.dta", replace
*Observations: 4,855







*****************************************************************************************************
**Replicating the variables creation for precise time (i.e., AT) instead of meal slot***
*****************************************************************************************************

***Read in food detail file with aln qlet, meal slot and exact time in***

use "/PATH/TO/FILE/Only complete MS and AT data full_7y.dta", clear




***STEP 1: Collapse grams and energy on all food items eaten in the same unique time, create new datafile with one line per eating occasion EO_fa07time.dta***.

sort aln qlet fa07day fa07time_coded

clonevar fa07time_codedclone=fa07time_coded
collapse (sum) Grams=fa07fdwt Energy_kcal=fa07kcal Energy_kJ=fa07kj (median) Time=fa07time_coded, by (aln qlet fa07day fa07time_codedclone) 
label variable Grams "Amount eaten (g) per eating occasion"
label variable Time "Time of eating occasion" 
label variable Energy_kcal "Energy intake (kcal) per eating occasion"
label variable Energy_kJ "Energy intake (kJ) per eating occasion"
rename fa07time_codedclone fa07time_coded
save "/PATH/TO/FILE/EO_fa07time.dta", replace




***STEP 2: Open new eating occasion level file and aggregate eating occasion within each day to generate timing and frequency variables per day***.

use "/PATH/TO/FILE/EO_fa07time.dta"

sort aln qlet fa07day fa07time_coded


***Convert time data into separate hour and minute variables to compute time in minutes since midnight, to be able to compute total eating period and intermeal intervals using subtraction (and for meaningful description on a continuous decimal scale)

gen MealHour = int(fa07time_coded/100)
gen MealMinute = fa07time_coded-(MealHour*100)
gen mealtime_minutes = (MealHour*60)+MealMinute

**Show 2 decimals
format %9.2f MealHour
format %9.2f MealMinute
format %9.2f mealtime_minutes

label variable mealtime_minutes "Time of eating occasion in minutes since midnight (based on exact time)"



***Collapse timing of eating occasions and count frequency of eating occasions in the same day***.

clonevar fa07dayclone=fa07day
collapse (firstnm) TimeFirst=mealtime_minutes (lastnm) TimeLast=mealtime_minutes (count) n_occasions=fa07day, by (aln qlet fa07dayclone) 
rename fa07dayclone fa07day
label variable TimeFirst "Time of first eating occasion (minutes since midnight)"
label variable TimeLast "Time of last eating occasion (minutes since midnight)"
label variable n_occasions "Total number of eating occasions (based on exact time)"


save "/PATH/TO/FILE/aggr.dta", replace





***STEP 3: Open day-level file and compute eating period variable, then collapse to person-level averages***.

use "/PATH/TO/FILE/aggr.dta"

***Estimate eating period by subtracting the first time of eating from the last time of eating, the eating period is the total time duration over which eating occurs in a day.
gen EatingPeriod = TimeLast-TimeFirst
label variable EatingPeriod "Time duration (minutes) over which eating occasion occur in a day) (based on exact time)"

***Estimate intermeal intervals 
gen InterMealInterval = EatingPeriod/n_occasions
label variable InterMealInterval "Estimated daily average intermeal interval (minutes) from EatingPeriod/n_occasions (based on exact time)"

**Show 2 decimals
format %9.2f EatingPeriod
format %9.2f InterMealInterval

***Collapse to person-level averages
sort aln qlet
collapse (mean) TimeFirst_mean_AT=TimeFirst TimeLast_mean_AT=TimeLast EatingPeriod_mean_AT=EatingPeriod InterMealInterval_mean_AT=InterMealInterval n_occasions_mean_AT=n_occasions (count) n_days=fa07day, by (aln qlet)
 
label variable TimeFirst_mean_AT "First time of eating (Mean over 3 days minutes since midnight) (based on exact time)"
label variable TimeLast_mean_AT "Last time of eating (Mean over 3 days minutes since midnight) (based on exact time)"
label variable EatingPeriod_mean_AT "Mean eating period (minutes) over 3 days (based on exact time)"
label variable InterMealInterval_mean_AT "Mean (across 3 days) of estimated daily average intermeal interval (minutes) from EatingPeriod/n_occasions (based on exact time)"
label variable n_occasions_mean_AT "Mean number of eating occasions (times per day) over 3 days (based on exact time)"
label variable n_days "Total number of days"


**Show 2 decimals
format %9.2f TimeFirst_mean_AT
format %9.2f TimeLast_mean_AT
format %9.2f EatingPeriod_mean_AT
format %9.2f InterMealInterval_mean_AT
format %9.2f n_occasions_mean_AT


save "/PATH/TO/FILE/TEMP.dta", replace


**Open person-level file containing time and frequency variables, save as Eating Architecture file and merge all subsequent variables created into this file.
use "/PATH/TO/FILE/TEMP.dta", clear
sort aln qlet
save "/PATH/TO/FILE/Eating Architecture_aln.dta", replace



***STEP 4: Create eating occasion size variables (means) by opening the eating occasion level file and collapsing energy or grams**.

use "/PATH/TO/FILE/EO_fa07time.dta", clear

sort aln qlet


**--- before collapsing the means across the 3 days, first collapse the means of grams and kcal per day, which is not done in previous steps
collapse (mean) Grams_ddd_AT=Grams EnergyKcal_ddd_AT=Energy_kcal EnergykJ_ddd_AT=Energy_kJ, by (aln qlet fa07day)
label variable Grams_ddd_AT "Mean amount eaten (g) per eating occasion per diet diary day (based on meal slot)"
label variable EnergyKcal_ddd_AT "Mean Energy intake (kcal) per occasion per diet diary day (based on meal slot)"
label variable EnergykJ_ddd_AT "Mean Energy intake (kJ) per occasion per diet diary day (based on meal slot)"
format %8.2f Grams_ddd_AT
format %8.2f EnergyKcal_ddd_AT
format %8.2f EnergykJ_ddd_AT

*Now collapsing those to generate means of g and kcal per EO averaged across 3 days**
collapse (mean) Grams_mean_AT=Grams_ddd_AT EnergyKcal_mean_AT=EnergyKcal_ddd_AT EnergykJ_mean_AT=EnergykJ_ddd_AT, by (aln qlet)
label variable Grams_mean_AT "Mean amount eaten (g) per eating occasion (based on meal slot)"
label variable EnergyKcal_mean_AT "Mean Energy intake (kcal) per occasion (based on meal slot)"
label variable EnergykJ_mean_AT "Mean Energy intake (kJ) per occasion (based on meal slot)"
format %8.2f Grams_mean_AT
format %8.2f EnergyKcal_mean_AT
format %8.2f EnergykJ_mean_AT


save "/PATH/TO/FILE/aggr.dta", replace



***Merging new average eating occasion size variables to Eating Architecture file***.
use "/PATH/TO/FILE/aggr.dta"
sort aln qlet

merge 1:1 aln qlet using "/PATH/TO/FILE/Eating Architecture_aln.dta", nogen
sort aln qlet


save "/PATH/TO/FILE/EA_AT_7y.dta", replace





***Merge MS (broad) and AT (precise) datasets
use "/PATH/TO/FILE/EA_MS_7y.dta", clear
merge 1:1 aln qlet using "/PATH/TO/FILE/EA_AT_7y.dta", nogen



save "/PATH/TO/FILE/Eating Architecture MS vs AT 7y.dta", replace





