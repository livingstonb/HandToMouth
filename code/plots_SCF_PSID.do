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
	ylabel(0(0.1)0.4)
	title("HtM for all households");
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
		title("HtM for households with >=1 government workers");
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
		title("HtM for private sector only households");
	restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_nongov.png, replace;
	
	* h2m by year -- not currently working;
	preserve;
	keep if (industry==0) & (industrysp==0);
	graph bar Wh2m Ph2m [aw=wgt], over(year) stack
		graphregion(color(white))
		legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
		intensity(*0.9)
		lintensity(*0.9)
		ylabel(0(0.1)0.4)
		title("HtM for households not currently employed");
	restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_nonempl.png, replace;
	
	* fraction of workers in gov,non-gov,unemp
	preserve;
	keep if Wh2m < .;
	gen govhh = (industry==7) | (industrysp==7);
	gen unemphh = (industry==0) & (industrysp==0);
	gen privatehh = !(govhh | unemphh);

	graph bar govhh privatehh unemphh [aw=wgt], over(year) stack
		graphregion(color(white))
		legend(label(1 ">=1 Gov Workers") label(2 "Private Sector Only") label(3 "Not Currently Working"))
		title("Sector composition")
		intensity(*0.9)
		lintensity(*0.9)
		ytitle("");
	capture restore;
	cd $basedir/stats/output;
	graph export ${dataset}_h2m_year_fractions.png, replace;
};
