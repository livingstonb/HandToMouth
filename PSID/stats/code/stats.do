#delimit;
clear*;
cd $BaseDir/build/output;
use PSID.dta;

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
cd $BaseDir/../code;
do compute_h2m.do;

* Compute yearly averages;
preserve;
cd $BaseDir/../code;
do yearly_h2m.do;
cd $BaseDir/stats/output;
save PSIDh2m_yearly.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PAPER DEFINITION - PLOT;

* Plot h2m by age;
cd $BaseDir/../code;
* rename headage age;
do plot_h2m_age.do;
cd $BaseDir/stats/output;
graph export PSID_h2m_age.png, replace;


////////////////////////////////////////////////////////////////////////////////
* NON-DURABLE CONSUMPTION & H2M;
* Compute h2m statistics here;
cd $BaseDir/../code;
do compute_h2m_consumption.do;

* Compute yearly averages;
preserve;
global dataset PSID;
cd $BaseDir/../code;
do yearly_h2m.do;
cd $BaseDir/stats/output;
save PSIDh2m_yearly_consumption.dta, replace;
restore;


