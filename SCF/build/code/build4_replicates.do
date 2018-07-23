clear

// this file adds a year variable to each replicate dataset for easy
// merging

cd ${basedir}/build/input/replicates
local yys 89 92 95 98 01 04 07 10 13 16 89 92 95 98
foreach yy of local yys {
	if `yy' > 80 {
		use p`yy'_rw1, clear
		gen year =  19`yy'
	}
	else {
		use p`yy'_rw1, clear
		gen year = 20`yy'
	}
	
	if `yy'==89 {
		rename X1 Y1
		rename XX1 YY1
	}
	else if `yy'==01 {
		rename wt1* mm* y1, upper
	}

	save ${basedir}/build/temp/rep`yy'.dta, replace
}
