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
gen 	incvar0 = netlabinc;
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

* Initialize;
local 	h2ms	h2m		Wh2m	Ph2m	NWh2m;
local 	model 	incvar 	clim 	liqvar 	payfreq illiqvar nwvar con;
foreach var of local model {;
	gen `var' = .;
};

////////////////////////////////////////////////////////////////////////////////
* LOOP OVER ALTERNATIVE SPECIFICATIONS;
forvalues spec=1(1)5 {;
	* Set to baseline;
	foreach var of local model {;
		replace `var' = `var'0;
	};
	global borrowlimtype 	$borrowlimtype0;
	global h2mtype			$h2mtype0;
	
	* Set new specification;
	if `spec'==1 {; 
		* baseline, no changes;
	};
	else if `spec'==2 {;
		* financially fragile;
		global h2mtype	finfrag;
	};
	else if `spec'==3 {;
		* 1-year income credit limit;
		replace clim = 12;
	};
	else if `spec'==4 {;
		* weekly pay period;
		replace payfreq = 4;
	};
	else if `spec'==5 {;
		* monthly pay period;
		replace payfreq = 1;
	};

	* Compute h2m statistics here;
	cd $basedir/../code;
	do compute_h2m.do;
	quietly mean `h2ms' [aw=wgt];
	matrix coeffs = e(b);

	* Store in matrix;
	if `spec'==1 {;
		matrix H2M = coeffs;
	};
	else {;
		matrix H2M = H2M\coeffs;
	};
	

	drop *h2m;
};
* Set matrix rownames;
matrix rownames H2M = base finfrag oneycredit wkpay mopay;
assert 0;

* Set back to baseline
foreach var of local model {;
	replace `var' = `var'0;
};
global borrowlimtype 	$borrowlimtype0;
global h2mtype			$h2mtype0;


////////////////////////////////////////////////////////////////////////////////
* PAPER DEFINITION - COMPUTE;

* Compute h2m statistics here;
cd $basedir/../code;
do compute_h2m.do;

* Compute yearly averages;
preserve;
global dataset PSID;
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


