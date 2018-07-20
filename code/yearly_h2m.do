#delimit;


foreach h2mvar of varlist *h2m  {;
	quietly mean(`h2mvar') [aw=wgt];
	matrix pooled = e(b);
	scalar scpooled_`h2mvar' = pooled[1,1];
};

if strmatch("$dataset","SCF")==1 {;
	collapse (mean) *h2m [aw=wgt], by(year im0100);
	collapse (mean) *h2m, by(year);
};
else {;
	collapse (mean) *h2m [aw=wgt], by(year);
};

xpose, clear varname;
gen pooled = 0;

xpose, clear;
replace year = 0 if year < 1;
tostring year, replace;

replace year = "Pooled" if _n == _N;
foreach h2mvar of varlist *h2m  {;
	replace `h2mvar' = scpooled_`h2mvar' if _n == _N;
};

foreach var of varlist *h2m {;
	replace `var' = round(`var',0.001);
};
