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
gen INCVAR = netlabinc;
* How many months of income to use as credit limit (1,2,...);
gen CLIM = 1;
* Select which liquid assets variable to use (netbrliq);
gen LIQVAR = netbrliq;
* Select pay frequency (n = n paychecks/month);
drop payfreq;
gen PAYFREQ = 2;
* Select illiquid wealth variable (familliqnv, familliqvehic);
gen ILLIQVAR = netbrilliqnc;
* Select net worth variable (famwealthvehic,famwealthnv);
gen NWVAR = networthnc;
* Borrowing limit type (normal,reported);
global BORROWLIMTYPE normal;
* h2m type (normal,commconsbeg,commconsend,finfrag);
global H2MTYPE normal;
* Select consumption variable;
gen CON = .;
* Declare the dataset;
global dataset SCF;

* Set to baseline;
gen incvar = INCVAR;
gen clim = CLIM;
gen liqvar = LIQVAR;
gen payfreq = PAYFREQ;
gen illiqvar = ILLIQVAR;
gen nwvar = NWVAR;
global borrowlimtype $BORROWLIMTYPE;
global h2mtype	$H2MTYPE;


////////////////////////////////////////////////////////////////////////////////
* LOOP THROUGH SPECIFICATIONS (chosen in loop_h2m.do), STORE RESULTS AS MATRIX;

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

* Plots;

cd $basedir/../code;
do plots_SCF_PSID.do;

////////////////////////////////////////////////////////////////////////////////
* SAVE MATRICES
* Baseline;
cd ${basedir}/stats/output;
use SCFh2m_yearly.dta;
list, clean noobs;
clear;

svmat H2Mrobust, names(col);
save H2Mrobust.dta, replace;
clear;

* Compute and save std errors;
svmat H2MrobustV, names(col);
foreach var of varlist *h2m {;
	replace `var' = sqrt(`var')
};
save H2Mrobust_stderrors.dta, replace;

matrix list H2Mrobust;
matrix list H2MrobustV;


