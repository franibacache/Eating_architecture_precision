********************************
** by: Francisca Ibacache
** date: 16/07/2023
********************************

* Analysis – Additional descriptives of precise EOs by meal slots



******* I. Create dataset to explore Size and Frequency of precise EOs by broad time slots (MS). *******


***Read in food detail file with aln qlet, meal slot and exact time in***
use "/PATH/TO/FILE/Only complete MS and AT data full_7y.dta", clear


*** Collapse grams and energy on all food items eaten in the same meal slot ***. 
sort id fa07day fa07time
clonevar fa07timeclone=fa07time
collapse (sum) Grams_MS=fa07fdwt Kcal_MS=fa07kcal, by (id fa07day fa07timeclone) 
label variable Grams_MS "Amount eaten (g) per occasion (based on meal slot)" 
label variable Kcal_MS "Energy intake (kcal) per occasion (based on meal slot)"
rename fa07timeclone Time_MS




gen Freq_MS = 1

*Summarise broad times (MS), freq, grams and kcal by MS times
collapse (mean) Grams_MS Kcal_MS Freq_MS, by (id Time_MS)

format %9.1f Grams_MS
format %9.1f Kcal_MS
format %9.1f Freq_MS

save "/PATH/TO/FILE/EOlevel_extrastep_MS.dta", replace



*****************************************************************************************************
***       Replicating the variables' creation for eprecise time (AT) instead of meal slot.        ***
*****************************************************************************************************

***Read in food detail file with aln qlet, meal slot and exact time in***
use "/PATH/TO/FILE/Only complete MS and AT data full_7y.dta", clear

sort id fa07day fa07time_coded

*Summarise precise times (AT), freq, grams and kcal by broad EOs(MS)
collapse (sum) Grams_AT=fa07fdwt Kcal_AT=fa07kcal, by (id fa07day fa07time fa07time_coded) 

rename fa07time Time_MS
rename fa07time_coded Time_AT
label variable Grams_AT "Amount eaten (g) per eating occasion"
label variable Time_AT "Time of eating occasion" 
label variable Kcal_AT "Energy intake (kcal) per eating occasion"


gen Freq_AT = 1


*collapse vars by day
collapse (mean) Grams_AT Kcal_AT (sum) Freq_AT, by (id fa07day Time_MS)


*collapse further to have only means per EO (indicated by the Time_MS here, but represents EOs by AT)
collapse (mean) Grams_AT Kcal_AT Freq_AT, by (id Time_MS)

format %9.1f Grams_AT
format %9.1f Kcal_AT
format %9.1f Freq_AT

save "/PATH/TO/FILE/EOlevel_extrastep_AT.dta", replace


*** Merge 2 created datasets. ***
use "/PATH/TO/FILE/EOlevel_extrastep_MS.dta", clear
merge 1:1 id Time_MS using "/PATH/TO/FILE/EOlevel_extrastep_AT.dta"
drop _merge

save "/PATH/TO/FILE/EOlevel_extrastep.dta", replace



*------------------------------------------------------------------------------*


******* II. Intervals between multiple EOs within a MS. *******


* Read in food detail file with aln qlet, meal slot and exact time in

use "/PATH/TO/FILE/Only complete MS and AT data full_7y.dta", clear


***STEP 1: Collapse grams and energy on all food items eaten in the same unique time, create new datafile with one line per eating occasion ***.

sort aln qlet fa07day fa07time_coded

clonevar fa07time_codedclone=fa07time_coded
collapse (sum) Grams=fa07fdwt Energy_kcal=fa07kcal Energy_kJ=fa07kj (median) Time=fa07time_coded, by (aln qlet fa07day fa07time_codedclone fa07time) 
label variable Grams "Amount eaten (g) per eating occasion"
label variable Time "Time of eating occasion" 
label variable Energy_kcal "Energy intake (kcal) per eating occasion"
label variable Energy_kJ "Energy intake (kJ) per eating occasion"
rename fa07time_codedclone fa07time_coded
save "/PATH/TO/FILE/EO_fa07time.dta", replace




***STEP 2: Open new eating occasion level file and aggregate eating occasion within each day to generate timing and frequency variables per day***.

use "/PATH/TO/FILE/EO_fa07time.dta", clear 

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

egen id = concat(aln qlet)
order id
drop aln qlet Energy_kJ Energy_kcal Grams fa07time_coded MealHour MealMinute

rename mealtime_minutes TimeATmin
rename Time TimeAT
rename fa07time TimeMS


*Change dataset from long to wide
drop TimeAT
rename TimeATmin AT
sort id fa07day TimeMS AT 
bysort id fa07day TimeMS (TimeMS): generate newv = _n
reshape wide AT, i(id fa07day TimeMS) j(newv)

* Create new variable to get the avergae number of EO that are combined together
egen ATtotal = rownonmiss(AT1 - AT8)
summarize ATtotal, detail
* to get the mean of the EOs combined together in a MS when rows have more than 1 EO only.
summarize ATtotal if ATtotal != 1

*Generating Time difference variables (Intervals) 
gen Diff1 = AT2-AT1
gen Diff2 = AT3-AT2
gen Diff3 = AT4-AT3
gen Diff4 = AT5-AT4
gen Diff5 = AT6-AT5
gen Diff6 = AT7-AT6
gen Diff7 = AT8-AT7



egen MeanDiff = rowmean(Diff1 Diff2 Diff3 Diff4 Diff5 Diff6 Diff7)


save "/PATH/TO/FILE/Extrastep2_EOInterval.dta", replace





* Cleaning data so time differences between intervals are real (max 420 min sepaartion between EOS, which corresponds to 7 hrs -> 6am MS)

use "/PATH/TO/FILE/Extrastep2_EOInterval.dta", clear


* Create new variable to get the average number of EO that are combined together
egen ATtotal = rownonmiss(AT1 - AT8)
summarize ATtotal, detail
* to get the mean of the EOs combined together in a MS when rows have more than 1 EO only.
summarize ATtotal if ATtotal != 1



forvalues occ = 1/8{
                generate Correctslot`occ' = .
                replace Correctslot`occ' = 6 if (AT`occ'==1440) | AT`occ'>=0 & AT`occ'<=419
                replace Correctslot`occ' = 8 if AT`occ'>=420 & AT`occ'<=599
                replace Correctslot`occ' = 11 if AT`occ'>=600 & AT`occ'<=719
                replace Correctslot`occ' = 13 if AT`occ'>=720 & AT`occ'<=869
                replace Correctslot`occ' = 17 if AT`occ'>=870 & AT`occ'<=1019
                replace Correctslot`occ' = 20 if AT`occ'>=1020 & AT`occ'<=1169
                replace Correctslot`occ' = 22 if AT`occ'>=1170 & AT`occ'<=1439
                count if TimeMS!=Correctslot`occ' & Correctslot`occ'!=.
                local n = r(N)
                display "Occasion `occ', number of mis-matches: `n'"
                generate Flag_AT`occ' = 1 if TimeMS!=Correctslot`occ' & Correctslot`occ'!=.
                generate New_AT`occ' = AT`occ'
                replace New_AT`occ' = .a if TimeMS!=Correctslot`occ' & Correctslot`occ'!=.               
}



*Generating Time difference variables (Intervals) for the new AT vars
gen New_Diff1 = New_AT2-New_AT1
gen New_Diff2 = New_AT3-New_AT2
gen New_Diff3 = New_AT4-New_AT3
gen New_Diff4 = New_AT5-New_AT4
gen New_Diff5 = New_AT6-New_AT5
gen New_Diff6 = New_AT7-New_AT6
gen New_Diff7 = New_AT8-New_AT7


egen New_MeanDiff = rowmean(New_Diff1 New_Diff2 New_Diff3 New_Diff4 New_Diff5 New_Diff6 New_Diff7)

save "/PATH/TO/FILE/Extrastep2_EOInterval_v2.dta", replace




