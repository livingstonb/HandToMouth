#delimit;

/* This do-file computes mean h2m for any variety of h2m statistics
labelled XXXXX_h2m. Means are computed by year and for the pooled sample */;

* Get  pooled means;
/*
foreach h2mvar of varlist *h2m  {;
	quietly mean(`h2mvar') [aw=wgt];
	matrix pooled = e(b);
	scalar scpooled_`h2mvar' = pooled[1,1];
} */;

if ("$dataset"=="CEX") {;
	local h2ms h2m;
};
else {;
	local h2ms h2m Wh2m Ph2m NWh2m;
};

* Get means by year;
if ("$dataset"=="SCF") {;
	if ${stderror} == 1 {;
		gen modyear = mod(year,100);
		local yys 89 92 95 98 01 04 07 10 13 16;
		cap matrix drop h2mV;
		foreach yy of local yys {;
			cd ${basedir}/build/temp;
			merge 1:1 Y1 year using rep`yy', nogen;
			gen rep = im0100;
			rename WT1B* MM*, lower;
			* Find mean for each h2m definition;
			cap matrix drop h2mrep;
			foreach h2mdef of local h2ms {;
				scfcombo `h2mdef' if modyear ==`yy' [aw=wgt], command(regress) reps(200) imps(5) title(Y`yy');
				if "`h2mdef'"=="h2m" {;
					* initialize;
					matrix h2mrep = e(V);
				};
				else {;
					matrix h2mrep = h2mrep,e(V);
				};
			};
			if "`yy'"=="89" {;
				* initialize;
				matrix h2mV = h2mrep;
			};
			else {;
				matrix h2mV = h2mV\h2mrep;
			};
			
			drop wt1* mm* rep;
		};
		matrix colnames h2mV = `h2ms';
		matrix rownames h2mV = 89 92 95 98 01 04 07 10 13 16;
		matrix list h2mV;
	};
	collapse (mean) `h2ms' [aw=wgt], by(year im0100);
	collapse (mean) `h2ms', by(year);

};
else if inlist("$dataset","SHED","NFCS") {;
	collapse (mean) *_h2m [aw=wgt], by(year);
};
else {;
	collapse (mean) `h2ms' [aw=wgt], by(year);
};

/* Add pooled/averaged row by transposing, creating a new variable, and
transposing back */;
xpose, clear varname;

* gen pooled = 0;
egen average = rowmean(v*);

xpose, clear;
replace year = 0 if year < 1;
tostring year, replace;

/* replace year = "Pooled" if _n == _N;
foreach h2mvar of varlist *h2m  {;
	replace `h2mvar' = scpooled_`h2mvar' if _n == _N;
} */;
replace year = "Mean" if _n == _N;

foreach var of varlist *h2m {;
	replace `var' = round(`var',0.001);
};
