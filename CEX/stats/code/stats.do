#delimit;
clear*;
cd $basedir/build/output;
use CEXfmli.dta;
cap mkdir $basedir/stats/output;

/*
This file is where the user indicates how h2m will be computed. The file
compute_h2m.do is then called to perform the computations.
*/;

/* Output:
	robustness checks				- CEXrobust.dta
	robustness checks, stderrors	- CEXrobust_stderrors.dta
	yearly h2m statistics 			- CEXh2m_yearly.dta
	yearly h2m stats (consumption)	- CEXh2m_yearly_consumption.dta
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);
drop if (selfearn>0 & wages <=0);
drop if checking == .;
local samplesize = _N;

////////////////////////////////////////////////////////////////////////////////
* BASELINE H2M SPECIFICATION;
* Select which income variable to use (income_post,incomenobusfarm);
gen INCVAR 		= income_post;
	/* wages + selfearn + rentinc + othinc + othinc2 + pensioninc
		+ retsurvivor + uiben + localwelf + socsec + int_and_div + saleshousehold
		+ royalttrust + childsupp + othchildsupp + savint + workcomp */;
* How many months of income to use as credit limit (1,2,...);
gen CLIM 	= 1;
* Select which liquid assets variable to use (netbrliq);
gen LIQVAR 	= netbrliq;
* Select pay frequency (n = n paychecks/month);
gen PAYFREQ = 2;
* Select illiquid wealth variable (0);
gen ILLIQVAR = 0;
* Select net worth variable (0);
gen NWVAR 	= 0;
* Borrowing limit type (normal);
global BORROWLIMTYPE normal;
* h2m type (normal,finfrag);
global 	H2MTYPE normal;
* Select consumption variable;
gen CONSUMPTION 	= totalexp/0.7;
* Declare the dataset;
global dataset CEX;

* Estimate standard errors?;
global stderrors = 1;
if $stderrors == 1 {;
	replace INCVAR = imp_income_post;
};

* Set to baseline;
gen incvar = INCVAR;
gen clim = CLIM;
gen liqvar = LIQVAR;
gen payfreq = PAYFREQ;
gen illiqvar = ILLIQVAR;
gen nwvar = NWVAR;
gen consumption = CONSUMPTION;
global borrowlimtype $BORROWLIMTYPE;
global h2mtype	$H2MTYPE;

////////////////////////////////////////////////////////////////////////////////
* LOOP THROUGH SPECIFICATIONS (chosen in loop_h2m.do);
do ${basedir}/../code/loop_h2m.do;

////////////////////////////////////////////////////////////////////////////////
* BASELINE SPECIFICATION - COMPUTE H2M BY YEAR;

* Compute h2m statistics here;
cd $basedir/../code;
do compute_h2m.do;

* Compute yearly averages;
preserve;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save CEXh2m_yearly.dta, replace;
restore;

* Plots;
* h2m by age;
preserve;
collapse (mean) h2m [aw=wgt], by(age);
sort age;
graph twoway line h2m age, lpattern(solid)
	graphregion(color(white))
	legend(label(1 "Total Hand-to-Mouth")
	cols(1) region(lcolor(white))) xtitle("Age") ytitle("");
restore;
cd $basedir/stats/output;
graph export ${dataset}_h2m_age.png, replace;

////////////////////////////////////////////////////////////////////////////////
* CONSUMPTION HTM;
preserve;
drop if CONSUMPTION == 0;
local samplesize_consumption = _N;
do ${basedir}/../code/compute_h2m_consumption.do;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save CEXh2m_yearly_consumption.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
clear;
svmat samplesize;
outsheet using N.csv, comma replace;
clear;

* Baseline;
cd ${basedir}/stats/output;
di "BASELINE H2M:";
use CEXh2m_yearly.dta, clear;
li, clean noobs;

* Consumption;
cd ${basedir}/stats/output;
di "CONSUMPTION H2M:";
use CEXh2m_yearly_consumption.dta, clear;
li, clean noobs;

* Robustness checks;
clear;
svmat H2Mrobust, names(col);
cd ${basedir}/stats/output;
save CEXrobust.dta, replace;

* Compute and save std errors;
clear;
if ${stderrors}==1 {;
svmat H2MrobustV, names(col);
foreach var of varlist h2m {;
	replace `var' = sqrt(`var');
};
save CEXrobust_stderrors.dta, replace;
};

matrix list H2Mrobust;
if ${stderrors}==1 {;
	matrix list H2MrobustV;
};
