clear

// this file adds a year variable to each replicate dataset for easy
// merging

cd ${basedir}/build/input/replicates

use p19_rw1
rename *, upper
tempfile repsy19
save `repsy19'
clear

local yys 01 89 92 95 98 04 07 10 13 16 19
foreach yy of local yys {
	if `yy'==01 {
		use p01_rw1, clear
		gen year = 2001
		rename wt1* mm* y1, upper
	}
	else {

		if `yy'==19 {
			append using `repsy19'
		}
		else {
			append using p`yy'_rw1
		}

		if `yy' >= 89 {
			replace year = 19`yy' if year==.
		}
		else {
			replace year = 20`yy' if year==.
		}
	}
	
	
	if `yy'==89 {
		replace Y1 = X1 if year==1989
	}
	

}
rename WT* MM*, lower
replace YY1 = (Y1-mod(Y1,10))/10
save ${basedir}/build/temp/replicates.dta, replace

