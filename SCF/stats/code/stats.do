//////////////////////////////////////////////////////////////////////////////
#delimit;
set more 1;
cap mkdir $basedir/stats/output;

/* This is the main do-file for computing hand-to-mouth statistics for the SCF.
Written by Brian Livingston */;

cd $basedir/build/output;
use SCF_89_16_cleaned.dta, clear;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
* Age restrictions;
keep if age>=22 & age<=79;

* drop if negative labor income;
drop if labinc<0;

* drop if have only self employment income;
drop if (labearn1 == 0 & selfearn1>0) | (labearn2 == 0 &  selfearn2>0);

////////////////////////////////////////////////////////////////////////////////
* Select which income variable to use (labinc,netlabinc);
gen incvar0 = netlabinc;
* How many months of income to use as credit limit (1,2,...);
gen clim0 = 1;
* Select which liquid assets variable to use (netbrliq);
gen liqvar0 = netbrliq;
* Select pay frequency (n = n paychecks/month);
drop payfreq;
gen payfreq0 = 2;
* Select illiquid wealth variable (familliqnv, familliqvehic);
gen illiqvar0 = netbrilliqnc;
* Select net worth variable (famwealthvehic,famwealthnv);
gen nwvar0 = networthnc;
* Borrowing limit type (normal,reported);
global borrowlimtype0 normal;
* h2m type (normal,commconsbeg,commconsend,finfrag);
global h2mtype0 normal;
* Select consumption variable;
gen 	con0 		= .;
* Declare the dataset;
global dataset SCF;


////////////////////////////////////////////////////////////////////////////////
* LOOP THROUGH SPECIFICATIONS (chosen in loop_h2m.do);
do ${basedir}/../code/loop_h2m.do;


////////////////////////////////////////////////////////////////////////////////
* BASELINE SPECIFICATION - COMPUTE H2M BY YEAR;

* Compute h2m statistics here;
cd $basedir/../code;
do compute_h2m.do;

* Average h2m by year;
preserve;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save SCFh2m_yearly.dta, replace;
restore;


////////////////////////////////////////////////////////////////////////////////
* PLOTS;

cd $basedir/stats/code;
do stats_plots.do;


