#delimit;
set more 1;
clear*;
cap mkdir $basedir/build/output;

/* This script cleans the NFCS data and saves NFCS.dta to build/output */;

////////////////////////////////////////////////////////////////////////////////
* CLEAN DATA;
cd $basedir/build/input;
insheet using NFCS2015.csv, comma;

destring j20, gen(get2000);

label define confidence2000 
	1 "Certain could come up with $2000"
	2 "Could probably come up with $2000" 
	3 "Probably not come up with $2000"
	4 "Could not come up with $2000" 
	98 "Don't know" 
	99 "Prefer not to say";
label values get2000 confidence2000;

replace get2000 = . if inlist(get2000,98,99);

* Create dummies;
gen 	get2000certain 		= get2000 == 1;
gen 	get2000probably 	= get2000 == 2;
gen 	get2000probablynot 	= get2000 == 3;
gen 	get2000not 			= get2000 == 4;
gen		get2000bottom		= inlist(get2000,3,4);
replace get2000certain 		= . if get2000 == .;
replace get2000probably 	= . if get2000 == .;
replace get2000probablynot 	= . if get2000 == .;
replace get2000not 			= . if get2000 == .;
replace get2000bottom		= . if get2000 == .;

label variable get2000certain 		"Could certainly come up with $2000";
label variable get2000probably 		"Could probably come up with $2000";
label variable get2000probablynot 	"Could probably not come up with $2000";
label variable get2000not 			"Could not come up with $2000";

rename wgt_n2 	wgt;
rename a3ar_w 	agegrp;
rename track 	year;


////////////////////////////////////////////////////////////////////////////////
* SAVE;
cd $basedir/build/output;
save NFCS.dta, replace;
