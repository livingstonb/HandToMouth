#delimit;

/* This do-file loops through different h2m specifications, calling
compute_h2m each time and storing the results in a matrix */;

* Initialize;
if ("$dataset"=="CEX") {;
	local h2ms h2m;
};
else {;
	local h2ms h2m Wh2m Ph2m NWh2m;
};

if strmatch("$dataset","SCF")==1 {;
	cd ${basedir}/build/temp;
	merge m:1 YY1 year using replicates.dta, nogen;
	gen rep = im0100;
};

////////////////////////////////////////////////////////////////////////////////
* LOOP OVER ALTERNATIVE SPECIFICATIONS;
forvalues spec=1(1)5 {;
	
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
	if ("$dataset"=="SCF") & (${stderrors}==1) {;
		foreach h2mdef of local h2ms {;
			scfcombo `h2mdef' [aw=wgt], command(regress) reps(200) imps(5);
			if "`h2mdef'"=="h2m" {;
				matrix h2mrobust = e(b);
				matrix h2mrobustV = e(V);
			};
			else {;
				matrix h2mrobust = h2mrobust,e(b);
				matrix h2mrobustV = h2mrobustV,e(V);
			};
		};
	};
	else {;
		quietly mean `h2ms' [aw=wgt];
		matrix h2mrobust = e(b);
		matrix h2mrobustV = (.,.,.,.,.);
	};

	* Store in matrix;
	if `spec'==1 {;
		matrix H2Mrobust = h2mrobust;
		matrix H2MrobustV = h2mrobustV;
	};
	else {;
		matrix H2Mrobust = H2Mrobust\h2mrobust;
		matrix H2MrobustV = H2MrobustV\h2mrobustV;
	};
	

	drop *h2m;
	
	* Set back to baseline;
	replace incvar = INCVAR;
	replace clim = CLIM;
	replace liqvar = LIQVAR;
	replace payfreq = PAYFREQ;
	replace illiqvar = ILLIQVAR;
	replace nwvar = NWVAR;
	global borrowlimtype 	$BORROWLIMTYPE;
	global h2mtype			$H2MTYPE;
};

* Set matrix row and column names;
matrix colnames H2Mrobust = h2m Wh2m Ph2m NWh2m;
matrix colnames H2MrobustV = h2m Wh2m Ph2m NWh2m;
matrix rownames H2Mrobust = base finfrag oneycredit wkpay mopay;
matrix rownames H2MrobustV = base finfrag oneycredit wkpay mopay;
