clear
set more off
capture log close

cd "C:\Users\Student\OneDrive - Dickinson College\Documents\Dickinson\Spring 2024\DATA 400\Data400_Spring24\Mini-project"

// Import dataset

import delimited "Political Violence Events.csv"

save "events.dta", replace

clear

// Import dataset
import delimited "State Trips.csv"

save "trips.dta", replace

// Merge datasets
merge 1:m date abb using "events.dta"

replace has_event = 0 if has_event == .

tab abb

drop if _merge == 2

gen date_numeric = date(date, "YMD")

drop if year(date_numeric) == 2024 & ((month(date_numeric) == 1 & day(date_numeric) > 13) | month(date_numeric) > 1)

sort date
tab abb

drop _merge date_numeric
order date year month week fips abb state 

tostring year, replace

replace year = substr(date, 1, 4)

* Convert date variables to Stata's date format
gen date_updated_d = date(date, "YMD")

save "master.dta", replace

clear

// Import dataset
import delimited "weekly_cases.csv"

drop if strlen(state) == 3 & state != "NYC"

save "temp.dta", replace

drop if state == "NYC" | state == "NY"

save "weekly_cases.dta", replace

clear

use "temp.dta"

keep if state == "NYC" | state == "NY"

* Collapse the data by summing up values based on date and state (NY and NYC)
collapse (sum) tot_cases new_cases tot_deaths new_deaths new_historic_cases new_historic_deaths, by(date_updated start_date end_date)

gen state = "NY"

save "temp.dta", replace

append using "weekly_cases.dta"

* Convert date variables to Stata's date format
gen date_updated_d = date(date_updated, "MDY")

sort date_updated_d
rename state abb

save "weekly_cases.dta", replace

merge 1:m date_updated_d abb using "master.dta"

drop if _merge == 1

drop date_updated _merge

order date_updated_d-week abb fips-has_event start_date-new_historic_deaths
sort date_updated_d

save "master.dta", replace

export delimited "master.csv", replace

exit