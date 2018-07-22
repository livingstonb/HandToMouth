#delimit;
clear*;
cd $basedir/build/output;
use CEXfmli.dta;
cap mkdir $basedir/stats/output;

/*
This file is where the user indicates how h2m will be computed. The file
compute_h2m.do is then called to perform the computations.
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);
drop if (YQ < quarterly("2013 Q2","YQ"));

////////////////////////////////////////////////////////////////////////////////
* BASELINE H2M SPECIFICATION;
* Select which income variable to use (labinc_post);
gen incvar0 = wages + selfearn + rentinc + othinc + othinc2 + pensioninc
		+ retsurvivor + uiben + localwelf + socsec + int_and_div + saleshousehold
		+ royalttrust + childsupp + othchildsupp + savint + workcomp;
* How many months of income to use as credit limit (1,2,...);
gen 	clim0 		= 1;
* Select which liquid assets variable to use (netbrliq);
gen 	liqvar0 	= netbrliq;
* Select pay frequency (n = n paychecks/month);
gen 	payfreq0 	= 2;
* Select illiquid wealth variable (netbrilliqnc);
gen 	illiqvar0 	= 0;
* Select net worth variable (networthnc);
gen 	nwvar0 		= 0;
* Borrowing limit type (normal);
global 	borrowlimtype0 normal;
* h2m type (normal,finfrag);
global 	h2mtype0 normal;
* Select consumption variable;
gen 	con0 		= 0;
* Declare the dataset;
global	dataset CEX;

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
save CEX_h2mstat.dta, replace;
restore;

* Plots;
cd $basedir/stats/code;
do stats_plots.do;


////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
* Baseline;
cd ${basedir}/stats/output;
use CEX_h2mstat.dta, clear;
li, clean noobs;

* Robustness checks;
matrix list H2M;
