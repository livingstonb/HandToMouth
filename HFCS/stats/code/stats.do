//////////////////////////////////////////////////////////////////////////////
#delimit;
set more 1;
cd $basedir/build/output;
use HFCS_cleaned, clear;
cap mkdir $basedir/stats/output;

/* This is the main do-file for computing hand-to-mouth statistics for the HFCS.*/;

/* Output:
	robustness checks 				- HFCSrobust.dta
	robustness checks std errors	- HFCSrobust_stderrors.dta
	yearly h2m stats				- HFCSh2m_yearly.dta
*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
* Age restrictions;
keep if age>=22 & age<=79;

* drop if negative labor income;
drop if labinc<0;

* drop if have only self employment income;
drop if labinc == 0 & selfearn>0;

* select country;
keep if sa0100 == "$country";

////////////////////////////////////////////////////////////////////////////////
* SELECT WHETHER TO COMPUTE STANDARD ERRORS;
global stderrors 0;

////////////////////////////////////////////////////////////////////////////////
* Select which income variable to use (labinc,netlabinc);
gen INCVAR = labinc;
* How many months of income to use as credit limit (1,2,...);
gen CLIM = 1;
* Select which liquid assets variable to use (netbrliq);
gen LIQVAR = netbrliq;
* Select pay frequency (n = n paychecks/month);
cap drop payfreq;
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
gen CONSUMPTION = .;
* Declare the dataset;
global dataset HFCS;

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
save HFCSh2m_yearly_${country}.dta, replace;
restore;


////////////////////////////////////////////////////////////////////////////////
* SAVE MATRICES
* Baseline;
cd ${basedir}/stats/output;
use HFCSh2m_yearly_${country}.dta, clear;
list, clean noobs;
clear;

svmat H2Mrobust, names(col);
save HFCSrobust_${country}.dta, replace;
clear;

* Compute and save std errors;
if ${stderrors}==1 {;
svmat H2MrobustV, names(col);
foreach var of varlist *h2m {;
	replace `var' = sqrt(`var');
};
save HFCSrobust_stderrors_${country}.dta, replace;
};

matrix list H2Mrobust;
if ${stderrors}==1 {;
matrix list H2MrobustV;
};


