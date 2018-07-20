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
* Select which income variable to use (labinc_post);
gen incvar = labinc_post;
* How many months of income to use as credit limit (1,2,...);
gen clim = 1;
* Select which liquid assets variable to use (netbrliq);
gen liqvar = netbrliq;
* Select pay frequency (n = n paychecks/month);
gen payfreq = 2;
* Select illiquid wealth variable (netbrilliqnc);
gen illiqvar = netbrilliqnc;
* Select net worth variable (networthnc);
gen nwvar = networthnc;
* Borrowing limit type (normal);
global borrowlimtype normal;
* h2m type (normal,finfrag);
global h2mtype normal;

* Select consumption variable;
gen con = ndur;


////////////////////////////////////////////////////////////////////////////////
* PAPER DEFINITION - COMPUTE;

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
* Compute h2m statistics here;
cd $basedir/../code;
do compute_h2m_consumption.do;

* Compute yearly averages;
preserve;
global dataset PSID;
cd $basedir/../code;
do yearly_h2m.do;
cd $basedir/stats/output;
save PSIDh2m_h2mstat_consumption.dta, replace;
restore;


