#delimit;
clear*;
cd $basedir/build/output;
use PSID.dta;
cap mkdir $basedir/stats/output;

/* This is the main do-file for computing hand-to-mouth statistics for the SCF*/;

/* Output:
	robustness checks 	- PSIDrobust.dta
	yearly h2m stats	- PSIDh2m_yearly.dta
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);
drop if labinc < 0;
drop if truncw == 1;

////////////////////////////////////////////////////////////////////////////////
* BASELINE H2M SPECIFICATION;
* Select which income variable to use (labinc_post);
gen 	INCVAR = labinc_post;
* How many months of income to use as credit limit (1,2,...);
gen 	CLIM 		= 1;
* Select which liquid assets variable to use (netbrliq);
gen 	LIQVAR 	= netbrliq;
* Select pay frequency (n = n paychecks/month);
gen 	PAYFREQ 	= 2;
* Select illiquid wealth variable (netbrilliqnc);
gen 	ILLIQVAR 	= netbrilliqnc;
* Select net worth variable (networthnc);
gen 	NWVAR 		= networthnc;
* Borrowing limit type (normal);
global 	BORROWLIMTYPE normal;
* h2m type (normal,finfrag);
global 	H2MTYPE normal;
* Select consumption variable;
gen 	CONSUMPTION 		= ndur;
* Declare the dataset;
global dataset PSID;

global stderrors 0;

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
save PSIDh2m_yearly.dta, replace;
restore;

* Plots;
cd $basedir/../code;
do plots_SCF_PSID.do;

////////////////////////////////////////////////////////////////////////////////
* CCDEBT AS LIQDEBT - COMPUTE H2M BY YEAR FOR 2011-2015;
preserve;
* Drop earlier years;
drop if year < 2011;
* Set liqvar to ccdebt;
cap drop liqvar;
gen liqvar = checking + stocks - ccdebt;

* Compute h2m statistics here;
cap drop *h2m;
cd $basedir/../code;
do compute_h2m.do;

* Plot h2m by year;
cd $basedir/../code;
* do plot_h2m_year.do;
cd $basedir/stats/output;
* graph export PSIDh2m_yearly_2011_2015.png, replace;
restore;
////////////////////////////////////////////////////////////////////////////////
* SHOW RESULTS IN COMMAND WINDOW;
clear;
svmat samplesize;
outsheet using N.csv, comma replace;
clear;

* Baseline;
cd ${basedir}/stats/output;
use PSIDh2m_yearly.dta, clear;
li, clean noobs;


* Robustness checks;
clear;
svmat H2Mrobust, names(col);
cd ${basedir}/stats/output;
save PSIDrobust.dta, replace;
matrix list H2Mrobust;
