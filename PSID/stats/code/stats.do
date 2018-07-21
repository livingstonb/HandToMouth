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
keep if (age>=25) & (age<=79);

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

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

cd $basedir/stats/code;
do stats_plots.do;


////////////////////////////////////////////////////////////////////////////////
* NON-DURABLE CONSUMPTION & H2M;
scalar h2m_consumption = 0;
if h2m_consumption==1 {;
	* Compute h2m statistics here;
	cd $basedir/../code;
	do compute_h2m_consumption.do;

	* Compute yearly averages;
	preserve;
	cd $basedir/../code;
	do yearly_h2m.do;
	cd $basedir/stats/output;
	save PSIDh2m_h2mstat_consumption.dta, replace;
	restore;
};

////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
cd ${basedir}/stats/output;
use PSID_h2mstat.dta, clear;
li, clean noobs;

matrix list H2M;
