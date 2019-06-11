* Stata code to generate Table 1 from GBD estimates for NCD mortality 30-70 and 70-90 years

* data source: GBD 2017, available from http://ghdx.healthdata.org/gbd-results-tool

use GBD_age_spec_NCD_mortality.dta, replace

collapse (sum) population deaths, by(WHO_region sex agegp cause year)

gen premature="30 to 69" if substr(agegp,1,1)<"7"
replace premature="70 to 89" if premature==""

collapse (sum) population deaths, by(premature year sex WHO_region cause)
order premature year sex WHO_region cause population deaths

save GBD_table_1, replace

* collapse separately for each category in the table

* by year
use GBD_table_1, replace
collapse (sum) deaths (mean) population, by(premature year sex WHO_region)
collapse (sum) deaths population, by(premature year)
gen mort_rate=deaths*1000/population
format %12.0f deaths population
list

* totals of deaths
collapse (sum) deaths, by(premature)
list

* by sex
use GBD_table_1, replace
collapse (sum) deaths (mean) population, by(premature year sex WHO_region)
collapse (sum) deaths population, by(premature sex)
gen mort_rate=deaths*1000/population
format %12.0f deaths population
list

* by region
use GBD_table_1, replace
collapse (sum) deaths (mean) population, by(premature year sex WHO_region)
collapse (sum) deaths population, by(premature WHO_region)
gen mort_rate=deaths*1000/population
format %12.0f deaths population
list

* by cause
use GBD_table_1, replace
collapse (sum) deaths (mean) population, by(premature year sex WHO_region cause)
collapse (sum) deaths population, by(premature cause)
gen mort_rate=deaths*1000/population
format %12.0f deaths population
list



