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
	yearly h2m statistics 			- CEXh2m_yearly.dta
	yearly h2m stats (consumption)	- CEXh2m_yearly_consumption.dta
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);
drop if (YQ < quarterly("2013 Q2","YQ"));
drop if (selfearn>0 & wages <=0);
drop if checking == .;
local samplesize = _N;

////////////////////////////////////////////////////////////////////////////////
* BASELINE H2M SPECIFICATION;
* Select which income variable to use (income_post,incomenobusfarm);
gen incvar0 		= income_post;
	/* wages + selfearn + rentinc + othinc + othinc2 + pensioninc
		+ retsurvivor + uiben + localwelf + socsec + int_and_div + saleshousehold
		+ royalttrust + childsupp + othchildsupp + savint + workcomp */;
* How many months of income to use as credit limit (1,2,...);
gen 	clim0 		= 1;
* Select which liquid assets variable to use (netbrliq);
gen 	liqvar0 	= netbrliq;
* Select pay frequency (n = n paychecks/month);
gen 	payfreq0 	= 2;
* Select illiquid wealth variable (0);
gen 	illiqvar0 	= 0;
* Select net worth variable (0);
gen 	nwvar0 		= 0;
* Borrowing limit type (normal);
global 	borrowlimtype0 normal;
* h2m type (normal,finfrag);
global 	h2mtype0 normal;
* Select consumption variable;
gen 	con0 		= totalexp/0.7;
* Declare the dataset;
global	dataset CEX;

* Set to baseline;
global model incvar clim liqvar payfreq illiqvar nwvar con;
foreach var of global model {;
	replace `var' = `var'0;
};
global borrowlimtype 	$borrowlimtype0;
global h2mtype			$h2mtype0;

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
save CEXh2m_y.dta, replace;
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
drop if con == 0;
local samplesize_consumption = _N;
do ${basedir}/../code/compute_h2m_consumption.do;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save CEXh2m_yearly_consumption.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
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
svmat H2M, names(col);
cd ${basedir}/stats.output;
save H2Mrobust.dta;
matrix list H2M;

di "SAMPLE SIZE (BASELINE) = " `samplesize';
di "SAMPLE SIZE (CONSUMPTION) = " `samplesize_consumption';
