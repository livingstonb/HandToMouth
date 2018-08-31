cd ${basedir}/build/temp
use HFCS1.dta, clear
append using HFCS2.dta
cap mkdir ${basedir}/build/output

merge m:1 id wave im0100 using ${basedir}/build/temp/cash1.dta, nogen
merge m:1 id wave im0100 using ${basedir}/build/temp/cash2.dta, nogen

gen labincwork = .
replace labincwork = labinc if age<=59


*-----------------
*DEFINITIONS
*-----------------
* gen cashfrac 	= 139/2500 // from US
gen cashfrac = 0
gen liqpos      = checking*(1+cashfrac)
gen liqneg      = ccdebt
gen direct      = nmmf + stocks + bond
gen direct_eq   = deq
gen direct_bond = direct - deq
gen housepos    = houses + oresre
gen houseneg    = resdbt + heloc
gen nethouse    = housepos - houseneg
gen heloc_lim   = nethouse + heloc
replace heloc_lim = 0 if heloc_lim < 0
gen netcars     = vehic
gen selfearn	= hh_selfy
// france puts cars and other valuables together
replace netcars = da1131 if sa0100 == "FR"

gen sb          = 0
gen savbnd      = 0
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
rename hng0710 taxes
replace taxes = taxes*inc_HICP_adj
gen netlabinc = labinc - taxes
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

////////////////////////////////////////////////////////////////////////////////

cd ${basedir}/build/output
save HFCS_cleaned.dta, replace
