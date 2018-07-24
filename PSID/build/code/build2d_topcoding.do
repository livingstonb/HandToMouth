#delimit;
clear;
set more 1;

/* Top-codes the family and wealth dataset */;
/* NOT ACTUALLY BEING USED YET */;

cd ${basedir}/build/temp;
use fam1c.dta;

gen trunc = 0;

///////////////////////////////////////////////////////////////////////////////

* 998 - 999 Variables;
foreach var of varlist 


* 9,998 - 9,999 Variables;


* 99,998 - 99,999 Variables;


* 999,998 - 999,999 Variables;
foreach var of varlist {;
	replace `var' = 0 if inlist(`var',999998,999999);
	replce	trunc = 1 if `var'==;
};


* 9,999,998 - 9,999,999 Variables;
foreach var of varlist othdebt studentdebt {;
	replace `var' = 0 if inlist(`var',9999998,9999999);
	replce	trunc = 1 if inlist(`var',-999997,9999997);
};

* 999,999,998 - 999,999,999 Variables;
foreach var of varlist bus busdebt othrealestatedebt {;
	replace `var' = 0 if inlist(`var',999999998,999999999);
	replce	trunc = 1 if inlist(`var',999999997,-99999997) if year > 2011;
	replce	trunc = 1 if `var'==999999997 if year > 2011;
	replace	trunc = 1 if inlist(`var',999999997,-99999999) if year == 2011;
};


save cd ${basedir}/build/temp;
save fam1d.dta
