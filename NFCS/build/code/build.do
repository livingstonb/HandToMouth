#delimit;
set more 1;
clear*;
cap mkdir $basedir/build/output;
cap mkdir $basedir/build/temp;

/* This script cleans the NFCS data and saves NFCS.dta to build/output */;

////////////////////////////////////////////////////////////////////////////////
* CLEAN DATA;
cd $basedir/build/input;
insheet using NFCS2015.csv, comma;
gen year = 2015;
cd $basedir/build/temp;
save NFCS2015, replace;
cd $basedir/build/input;
insheet using NFCS2012.csv, clear comma;
gen year = 2012;
cd $basedir/build/temp;
append using NFCS2015;

rename j20 get2000;

label define confidence2000 
	1 "Certain could come up with $2000"
	2 "Could probably come up with $2000" 
	3 "Probably not come up with $2000"
	4 "Could not come up with $2000" 
	98 "Don't know" 
	99 "Prefer not to say";
label values get2000 confidence2000;



* Create dummies;
gen 	get2000certain 		= get2000 == 1;
gen 	get2000probably 	= get2000 == 2;
gen 	get2000probablynot 	= get2000 == 3;
gen 	get2000not 			= get2000 == 4;
gen		get2000top			= inlist(get2000,1,2);
gen		get2000bottom		= inlist(get2000,3,4);

label variable get2000certain 		"Could certainly come up with $2000";
label variable get2000probably 		"Could probably come up with $2000";
label variable get2000probablynot 	"Could probably not come up with $2000";
label variable get2000not 			"Could not come up with $2000";

* Rename other variables;
rename 	wgt_n2 	weight;
drop	wgt*;
rename 	weight 	wgt;
rename 	a3ar_w 	agegrp;
rename 	j30		timediscount;
rename	j5		rainyday;
rename	j4		paybills;
rename	j3		spendinc;

* Label variables;
label 	define	timediscountlab 1 "Next few months" 2 "Next year"
	3 "Next few years" 4 "Next 5 to 10 years" 5 "Longer than 10 years";
label 	values	timediscount timediscountlab;

* Missing values;
local missing9899 get2000 timediscount rainyday paybills spendinc;
foreach missvar of local missing9899 {;
	replace `missvar' = . if inlist(`missvar',98,99);
};

foreach missvar of varlist get2000* {;
	replace `missvar' = . if get2000 == .;
};


////////////////////////////////////////////////////////////////////////////////
* SAVE;
cd $basedir/build/output;
save NFCS.dta, replace;
