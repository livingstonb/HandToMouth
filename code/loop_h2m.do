#delimit;

/* This do-file loops through different h2m specifications, calling
compute_h2m each time and storing the results in a matrix */;

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

* Set back to baseline;
foreach var of local model {;
	replace `var' = `var'0;
};
global borrowlimtype 	$borrowlimtype0;
global h2mtype			$h2mtype0;
