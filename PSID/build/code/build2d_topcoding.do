#delimit;
clear;

/* IDENTIFY TOP-CODED DATA IN PSID */;

cd ${basedir}/build/temp/;
use fam1c;

* Truncated observations;
gen truncw = 0;


////////////////////////////////////////////////////////////////////////////////
* WEALTH VARIABLES;

* 9,999,997  - 9,999,999;
foreach var of varlist othdebt studentdebt y {;
	replace `var' = 0 if inlist(`var',9999998,9999999);
	replace truncw = 1 if `var'==9999997;
};

* 999,999,997-999,999,999;
foreach var of varlist bus busdebt othrealestatedebt othrealestate {;
	replace `var' = 0 if inlist(`var',999999998,999999999);
	replace truncw = 1 if inlist(`var',-99999999,999999997);
};



cd ${basedir}/build/temp;
save fam1d, replace;
