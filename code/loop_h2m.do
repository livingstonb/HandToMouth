#delimit;

/* This do-file loops through different h2m specifications, calling
compute_h2m each time and storing the results in a matrix */;

* Initialize;
if "$dataset"=="CEX" {;
	local h2ms h2m;
};
else {;
	local h2ms h2m Wh2m Ph2m NWh2m;
};

if "$dataset"=="SCF" & ${stderrors}==1 {;
	cd ${basedir}/build/temp;
	merge m:1 YY1 year using replicates.dta, nogen;
	gen rep = im0100;
};
else if "$dataset"=="HFCS" & ${stderrors}==1 {;
	cd ${basedir}/build/temp;
	merge m:1 id wave using ${basedir}/build/input/HFCS1_3/W.dta, nogen;
	merge m:1 id wave using ${basedir}/build/input/HFCS2_1/W.dta, nogen;
	local count = 1;
	foreach var of varlist wr* {;
		rename `var' wt1b`count';
		local countback = 1000 - `count';
		gen mm`countback' = 1;
		local count = `count' + 1;
	};
	gen rep = im0100;
};
else if "$dataset"=="PSID" {;
gen im0100 = 1;
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
	if ${stderrors}==1 & inlist("${dataset}","SCF","HFCS","CEX") {;
		if inlist("${dataset}","SCF","HFCS") {;
			local totalreps 200;
		};
		else if "${dataset}"=="CEX" {;
			local totalreps 44;
		};
		foreach h2mdef of local h2ms {;
			scfcombo `h2mdef' [aw=wgt], command(regress) reps(`totalreps') imps(5);
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
	
	* Record sample size;
	count if im0100==1 & h2m<.;
	if `spec'==1 {;
		matrix samplesize = r(N);
	};
	else {;
		matrix samplesize = samplesize\r(N);
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
	replace consumption = CONSUMPTION;
	global borrowlimtype 	$BORROWLIMTYPE;
	global h2mtype			$H2MTYPE;
};

* Set matrix row and column names;
matrix colnames H2Mrobust = `h2ms';
matrix colnames H2MrobustV = `h2ms';
matrix rownames H2Mrobust = base finfrag oneycredit wkpay mopay;
matrix rownames H2MrobustV = base finfrag oneycredit wkpay mopay;
