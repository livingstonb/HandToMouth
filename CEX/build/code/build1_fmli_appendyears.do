#delimit;
clear*;
set more 1;
cap mkdir ${basedir}/build/temp;
////////////////////////////////////////////////////////////////////////////////

* Create yearly datasets first;
foreach yy of numlist 97/99 0/16 {;
	forvalues q = 1/4 {;
		di "Reading `yy'q`q'";
		if (`yy'>=0) & (`yy'<=9) & (`q'==1) {;
			* Add leading 0 and x;
			local filename intrvw0`yy'/intrvw0`yy'/fmli0`yy'`q'x;
		};
		else if (`yy'>=0) & (`yy'<=9) & (`q'>1){;
			* Add leading 0;
			local filename intrvw0`yy'/intrvw0`yy'/fmli0`yy'`q';
		};
		else if `q'==1 {;
			* Add x;
			local filename intrvw`yy'/intrvw`yy'/fmli`yy'`q'x;
		};
		else {;
			local filename intrvw`yy'/intrvw`yy'/fmli`yy'`q';
		};
		
		cd ${basedir}/build/input;
		if `q'==1 {;
				use `filename', clear;
				gen q = `q';
		};
		else {;
			append using `filename';
			replace q = `q' if q==.;
		};
	};
	if (`yy'==15) | (`yy'==16) {;
		destring newid, replace;
	};
	if `yy' > 90 {;
		local yyyy 19`yy';
	};
	else if `yy'>=10 {;
		local yyyy 20`yy';
	};
	else {;
		local yyyy 200`yy';
	};
	gen year = `yyyy';
	save ${basedir}/build/temp/fmli`yyyy', replace;
};

* Append years;
foreach yyyy of numlist 1997/2016 {;
	if `yyyy'==1997 {;
		use ${basedir}/build/temp/fmli`yyyy', clear;
	};
	else {;
		append using ${basedir}/build/temp/fmli`yyyy';
	};
	rm ${basedir}/build/temp/fmli`yyyy'.dta;
};

* Save;
save ${basedir}/build/temp/fmli_allyears, replace;


