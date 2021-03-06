#delimit;

/* This do-file computes mean h2m for any variety of h2m statistics
labelled XXXXX_h2m. Means are computed by year and for the pooled sample */;

* For HFCS, do this by wave rather than year;
if "$dataset"=="HFCS" {;
	gen year = wave;
};

* Get  pooled means;
foreach h2mvar of varlist *h2m  {;
	quietly mean(`h2mvar') [aw=wgt];
	matrix pooled = e(b);
	scalar scpooled_`h2mvar' = pooled[1,1];
};

if ("$dataset"=="CEX") {;
	* Don't have data for other h2m statistics for CEX;
	local h2ms h2m;
};
else {;
	local h2ms h2m Wh2m Ph2m NWh2m;
};

* Get means by year;
if inlist("$dataset","SCF","HFCS","CEX") {;
	* Find point estimate for each imputation, then average over imputations;
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

gen pooled = 0;
egen average = rowmean(v*);

xpose, clear;
replace year = 0 if year < 1;
tostring year, replace;

replace year = "Pooled" if _n == _N-1;
foreach h2mvar of varlist *h2m  {;
	replace `h2mvar' = scpooled_`h2mvar' if _n == _N-1;
};
replace year = "Mean" if _n == _N;

foreach var of varlist *h2m {;
	replace `var' = round(`var',0.001);
};

if "$dataset"=="HFCS" {;
	rename year wave;
};
