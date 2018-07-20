//////////////////////////////////////////////////////////////////////////////
#delimit;
cap mkdir $basedir/stats/output;

cd $basedir/build/output;
use SCF_89_16_cleaned.dta, clear;

////////////////////////////////////////////////////////////////////////////////
* Select which income variable to use (labinc,netlabinc);
gen incvar = labinc;
* How many months of income to use as credit limit (1,2,...);
gen clim = 1;
* Select which liquid assets variable to use (netbrliq);
gen liqvar = netbrliq;
* Select pay frequency (n = n paychecks/month);
drop payfreq;
gen payfreq = 2;
* Select illiquid wealth variable (familliqnv, familliqvehic);
gen illiqvar = netbrilliqnc;
* Select net worth variable (famwealthvehic,famwealthnv);
gen nwvar = networthnc;
* Borrowing limit type (normal,reported);
global borrowlimtype normal;
* h2m type (normal,commconsbeg,commconsend,finfrag);
global h2mtype normal;

////////////////////////////////////////////////////////////////////////////////
* sample selection;
*AGE RESTRICTIONS;
keep if age>=22 & age<=79;

* drop if negative labor income;
drop if labinc<0;

* drop if have only self employment income;
drop if (labearn1 == 0 & selfearn1>0) | (labearn2 == 0 &  selfearn2>0);
////////////////////////////////////////////////////////////////////////////////


* Compute h2m statistics here;
global dataset SCF;
cd $basedir/../code;
do compute_h2m.do;


////////////////////////////////////////////////////////////////////////////////
* COMPUTE STATISTICS;

* Compute yearly h2m;
preserve;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save SCFh2m_yearly.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

* Plot h2m by age;
cd $basedir/stats/code;
do stats_plots.do;


