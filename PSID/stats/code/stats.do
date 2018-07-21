#delimit;
clear*;
cd $basedir/build/output;
use PSID.dta;
cap mkdir $basedir/stats/output;

/*
This file is where the user indicates how h2m will be computed. The file
compute_h2m.do is then called to perform the computations.
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);

////////////////////////////////////////////////////////////////////////////////
* BASELINE H2M SPECIFICATION;
* Select which income variable to use (labinc_post);
gen 	incvar0 = labinc_post;
* How many months of income to use as credit limit (1,2,...);
gen 	clim0 		= 1;
* Select which liquid assets variable to use (netbrliq);
gen 	liqvar0 	= netbrliq;
* Select pay frequency (n = n paychecks/month);
gen 	payfreq0 	= 2;
* Select illiquid wealth variable (netbrilliqnc);
gen 	illiqvar0 	= netbrilliqnc;
* Select net worth variable (networthnc);
gen 	nwvar0 		= networthnc;
* Borrowing limit type (normal);
global 	borrowlimtype0 normal;
* h2m type (normal,finfrag);
global 	h2mtype0 normal;
* Select consumption variable;
gen 	con0 		= ndur;
* Declare the dataset;
global dataset PSID;

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
save PSID_h2mstat.dta, replace;
restore;

* Plots;
cd $basedir/stats/code;
do stats_plots.do;


////////////////////////////////////////////////////////////////////////////////
* CCDEBT AS LIQDEBT - COMPUTE H2M BY YEAR FOR 2011-2015;

* Drop earlier years;
drop if year < 2011;
* Set liqvar to ccdebt;
cap drop liqvar;
gen liqvar = checking + stocks - ccdebt;

* Compute h2m statistics here;
drop *h2m;
cd $basedir/../code;
do compute_h2m.do;

* Plot h2m by year;
cd $basedir/../code;
do plot_h2m_year.do;
cd $basedir/stats/output;
graph export PSID_h2m_year20112015.png, replace;

////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
cd ${basedir}/stats/output;
use PSID_h2mstat.dta, clear;
li, clean noobs;

matrix list H2M;
