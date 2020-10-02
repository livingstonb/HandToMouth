clear
cap mkdir ${basedir}/build/output

// Code originally written by Justin Weidner


// this file generates all of the different definitions for the robustness checks

cd ${basedir}/build/temp
use SCF_89_19_merged.dta, clear

gen labincwork = .
replace labincwork = labinc if age<=59

*-----------------
*DEFINITIONS
*-----------------
gen cashfrac    = 138/2500 //average cash holdings excluding large value holdings divided by median liquid assets in 2010
gen liqpos      = liq*(1+cashfrac) //adjusted by cash holdings
gen liqneg      = ccdebt
gen direct      = nmmf + stocks + bond
gen housepos    = houses + oresre + nnresre
gen houseneg    = mrthel + resdbt
gen nethouse    = housepos - houseneg
gen netcars     = vehic
gen sb          = savbnd
gen certdep     = cds
gen retacc      = retqliq
gen lifeins     = cashli
gen netbus      = bus

// baseline
gen brliqpos      = liqpos + direct
gen brliqneg      = ccdebt
gen netbrliq      = brliqpos - brliqneg
gen brilliqpos    = housepos + netcars + certdep + retacc + lifeins
gen brilliqneg    = houseneg
gen netbrilliq    = brilliqpos - brilliqneg
gen netbrilliqnc  = netbrilliq - netcars
gen networthnc  = netbrilliqnc + netbrliq

// adds cars as illiquid
gen netbrilliqcars = netbrilliqnc + netcars
gen networthcars = netbrilliqnc + netbrliq + netcars

// adds businesses as illiquid
gen netbrilliqbusnc = netbrilliqnc + netbus
gen networthbusnc  = netbrilliqbusnc + netbrliq

// adds other valuables as illiquid
gen netbrilliqncmisc = netbrilliqnc + misc_illiq
gen networthncmisc = networthnc + misc_illiq

// takes HELOCs out of illiquid debt and puts it in liquid debt
gen netbrliqheloc = netbrliq - heloc
gen netbrilliqncheloc = netbrilliqnc + heloc

// puts retirement accounts in liquid assets for retirees
gen netbrliq_retirees = netbrliq
replace netbrliq_retirees = netbrliq + retacc if age >= 60
gen netbrilliqnc_retirees = netbrilliqnc
replace netbrilliqnc_retirees = netbrilliqnc - retacc if age >= 60

// puts stocks into illiquid
gen netbrliqnstocks = netbrliq - direct
gen netbrilliqncstocks = netbrilliqnc + direct
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// after tax income
gen netlabinc = labinc - taxes_mar_kids
gen netlabinc1 = labinc - taxes_sing_nokids
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// creates 5 year age bins
gen agedum = 0
replace agedum = 1 if age >= 22 & age <= 24
replace agedum = 2 if age >= 25 & age <= 29
replace agedum = 3 if age >= 30 & age <= 34
replace agedum = 4 if age >= 35 & age <= 39
replace agedum = 5 if age >= 40 & age <= 44
replace agedum = 6 if age >= 45 & age <= 49
replace agedum = 7 if age >= 50 & age <= 54
replace agedum = 8 if age >= 55 & age <= 59
replace agedum = 9 if age >= 60 & age <= 64
replace agedum = 10 if age >= 65 & age <= 69
replace agedum = 11 if age >= 70 & age <= 74
replace agedum = 12 if age >= 75 & age <= 79

label define l_age 1 "22-24", add
label define l_age 2 "25-29", add 
label define l_age 3 "30-34", add
label define l_age 4 "35-39", add
label define l_age 5 "40-44", add
label define l_age 6 "45-49", add
label define l_age 7 "50-54", add
label define l_age 8 "55-59", add
label define l_age 9 "60-64", add
label define l_age 10 "65-69", add
label define l_age 11 "70-74", add
label define l_age 12 "75-79", add
label values agedum l_age
////////////////////////////////////////////////////////////////////////////////


drop X*
cd ${basedir}/build/output
save SCF_89_19_cleaned.dta, replace

cd ${basedir}/build/temp
!rm SCF_89_19_merged.dta
