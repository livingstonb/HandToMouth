cd $basedir/build/temp
clear
set more off
// Code originally written by Justin Weidner
/* Generates tax-relevant variables and runs taxsim9 */

u fam1d, clear

//Manual adjustment
replace state=41 if year==2001&intid==6357
replace state=4 if year==2001&intid==1788
replace state=4 if year==2001&intid==7282

cap drop ftaxid
gen ftaxid = _n

cd $basedir/build/temp
save fam1b, replace

// ASSUME ALL INCOME IS LABOR INCOME WHEN CALCULATING FTAX
keep ftaxid year state marit kids age agew y ly wly asset tyhw tyoth childcare intid ndur truncw

gen stmp = state
replace stmp = stmp+1 if stmp>1 & stmp!=. //Alaska is 50 in PSID
replace stmp = 2 if stmp == 51
replace stmp = stmp+1 if stmp>11 & stmp!=. //Hawaii is 51 in PSID
replace stmp = 12 if stmp == 53 
replace state = stmp
drop stmp

//mstat: Marital status 1 for single, 2 for joint,
gen mstat = 1
replace mstat = 2 if marit == 1

gen depx = kids

gen agex = 0
replace agex = 2 if age>65&age<999&age!=. &(agew>65&agew<999&agew!=.)
replace agex = 1 if agex!=2 & (age>65&age<999&age!=.)
replace agex = 1 if agex!=2 & (agew>65&agew<999&agew!=.)

gen pwages = y*0.5
gen swages = y*0.5

gen depchild = kids

// if having problems with taxsim, set taxsim = 0
scalar taxsim = 0
if taxsim == 1 {
	taxsim9, replace

	gen ftax = fiitax
	gen stax = siitax
	

	keep ftaxid ftax stax

	sort ftaxid

	save ftax, replace
	save stax, replace

	u fam1b, clear

	sort ftaxid

	merge 1:1 ftaxid using ftax
	merge 1:1 ftaxid using stax, nogen
	tab _merge
	drop _merge ftaxid
}
else {
	gen ftax = 0
	gen stax = 0
}

sort intid year
cd $basedir/build/temp
save PSIDwealth, replace
