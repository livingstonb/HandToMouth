#delimit;

/* This do-file produces plots for the SCF or PSID when called by stats.do */;

////////////////////////////////////////////////////////////////////////////////
* h2m by age;
preserve;
collapse (mean) h2m (mean) Wh2m (mean) Ph2m (mean) NWh2m [aw=wgt], by(age);
sort age;
graph twoway line Ph2m age, lpattern(dash)
	|| line Wh2m age, lpattern(solid)
	graphregion(color(white))
	legend(label(1 "Poor Hand-to-Mouth") label(2 "Wealthy Hand-to-Mouth")
	cols(1) region(lcolor(white))) xtitle("Age");
restore;
cd $basedir/stats/output;
graph export ${dataset}_h2m_age.png, replace;

////////////////////////////////////////////////////////////////////////////////
* h2m by year -- overall;
preserve;
graph bar Wh2m Ph2m [aw=wgt], over(year) stack
	graphregion(color(white))
	legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
	intensity(*0.9)
	lintensity(*0.9)
	ylabel(0(0.1)0.4);
restore;
cd $basedir/stats/output;
graph export ${dataset}_h2m_year.png, replace;

////////////////////////////////////////////////////////////////////////////////
if "$dataset"=="SCF" {;
	* h2m by year -- gov workers;
	preserve;
	keep if (industry==7) | (industrysp==7);
	graph bar Wh2m Ph2m [aw=wgt], over(year) stack
		graphregion(color(white))
		legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
		intensity(*0.9)
		lintensity(*0.9)
		ylabel(0(0.1)0.4)
		title("HtM for families with >=1 government workers");
	restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_gov.png, replace;
	
	* h2m by year -- non-gov workers;
	preserve;
	keep if (industry!=7) & (industrysp!=7) & (industry!=0 | industrysp!=0);
	graph bar Wh2m Ph2m [aw=wgt], over(year) stack
		graphregion(color(white))
		legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
		intensity(*0.9)
		lintensity(*0.9)
		ylabel(0(0.1)0.4)
		title("HtM for families with no government workers");
	restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_nongov.png, replace;
	
	* fraction of workers in gov
	preserve;
	keep if Wh2m < .;
	drop if (industry==0) & (industrysp==0);
	gen govfam = (industry==7) | (industrysp==7);
	graph bar govfam [aw=wgt], over(year)
		graphregion(color(white))
		title("Fraction of families with >=1 government workers")
		intensity(*0.9)
		lintensity(*0.9)
		ytitle("");
	capture restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_fractiongov.png, replace;
};
