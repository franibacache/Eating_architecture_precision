********************************
** by: Francisca Ibacache
** date: 22/03/2022
********************************



* Data cleaning – Baseline cleaning of ALSPAC diet dataset. Some further cleaning was performed later for some of the analyses and specified in the respective script.
*NOTE: AT= precise times; MS: broad times.




use "/PATH/TO/FILE/ALSPAC DIET DATASET.dta", clear

***Set to missing (.) "99" values on fa07time column
replace fa07time = . if fa07time==99

***Set to missing (.) "99", "88" and values equal or over time 2400 on fa07time_coded column 
**#
set more off
quietly 
	foreach var of varlist fa07time_coded {
		replace `var'= . if `var'==99 | `var'==88 | `var'>=2400
}



*** Create indicator variable where indicator=0 means that row/instance has a non-missing AT; indicator=1 will indicate a row with missing AT.
generate indicator = 0
replace indicator= 1 if !missing(fa07time) & missing(fa07time_coded) 
tab aln if indicator == 1
order aln qlet indicator


egen id = concat(aln qlet)
order aln qlet id indicator
bysort id (indicator): generate _showme_1 = 1 if indicator[_N]==1 /*to flag all records, for people who have >=1 record of interest */
order aln qlet id indicator _showme_1



** how many rows someone has
bysort id: generate total_rows = _N

** how many rows of those are indicator ==1 and _showme_1 == 1 (i.e., how many people have non-missing meal slots and missing times)
bysort id: egen interesting_rows = total(indicator ==1)
order aln qlet id indicator _showme_1 total_rows interesting_rows
generate proportion_interesting = interesting_rows/total_rows

** how many rows of those are indicator ==1 and _showme_1 == 1
bysort id: egen totally_missing_rows = total(indicator ==0 & missing(fa07time))
order aln qlet id indicator _showme_1 total_rows totally_missing_rows
generate proportion_totally_missing = totally_missing_rows/total_rows
**Exploring Days with missing AT*
bysort id fa07day (indicator): generate _showme_2 = 1 if indicator[_N]==1 
order aln qlet id indicator _showme_1 total_rows interesting_rows totally_missing_rows proportion_interesting proportion_totally_missing _showme_2
*tab id fa07day if _showme_2 == 1 & indicator == 1 & missing(fa07time_coded)

*Creating a new variable calculating total number of rows per day (per person)
bysort id fa07day: gen tot_rows_day= _N
order aln qlet id indicator _showme_1 total_rows interesting_rows totally_missing_rows proportion_interesting proportion_totally_missing _showme_2 tot_rows_day

*Creating a new variable calculating number of rows per day (per person) with missing AT data
bysort id fa07day: egen missing_rows_day= total(fa07time_coded==.)
order aln qlet id indicator _showme_1 total_rows interesting_rows totally_missing_rows proportion_interesting proportion_totally_missing _showme_2 tot_rows_day missing_rows_day

*Creating new variable with the proportion of missingness per day (per person)
generate proportion_miss_day = missing_rows_day/tot_rows_day
order aln qlet id indicator _showme_1 total_rows interesting_rows totally_missing_rows proportion_interesting proportion_totally_missing _showme_2 tot_rows_day missing_rows_day proportion_miss_day


*Create indicator variables to know the people with completely missing AT data (this will include some of the situations where MS=. & AT=.). Then drop those people from this dataset to now end up with only people with partially missing AT data. 
 bysort id: egen totmissAT = total(fa07time_coded==.)
   generate proportion_missAT = totmissAT/total_rows
   tab id if proportion_missAT==1 /*2426 people; 135,269 obs */
   return list 
   order aln qlet id indicator _showme_1 total_rows interesting_rows totally_missing_rows proportion_interesting proportion_totally_missing _showme_2 tot_rows_day missing_rows_day proportion_miss_day totmissAT proportion_missAT
  
*Dropping rows (and people) with completely missing AT data.
   drop if proportion_missAT==1  /*(135,269 observations deleted)*/
   codebook id /*4,859 unique values*/

save "/PATH/TO/FILE/Partially missing AT full_7y.dta", replace  








******* ******* ******* ******* ******* 
******* Reporting missingness ******* 
******* ******* ******* ******* ******* 

use "/PATH/TO/FILE/Partially missing AT full_7y.dta", clear
** Exploring the observations that have the case of having some rows with MS=. & AT=.
list id fa07time fa07time_coded fa07name if missing(fa07time) & missing(fa07time_coded) /*so not all of these cases are for vitamins/medicines,there are some food items too */
tab id if missing(fa07time) & missing(fa07time_coded)
return list /* r(r) 133 people; 242 observations */
drop if missing(fa07time) & missing(fa07time_coded) /*dropping rows with MS=. & AT=. (242 observations deleted) */



* Dropped IDs where [MS=AT & that are left with an eating frequency of 1 (or 1.33, 1.67)] for AT (for example, they have only one exact time/data recorded for a time slot, which is not true, it's just that all of their other AT times are missing. These IDs have been previously identified when creating the EAVs. 

codebook id /* 4,855 unique values; Before(without dropping these 4 IDs): 4,859 unique values */

save "/PATH/TO/FILE/Partially missing AT v2 full_7y.dta", replace




















