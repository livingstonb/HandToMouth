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
	* h2m by race -- overall;
	local races white black hispanic;
	forvalues irace = 1/4 {;
		preserve;
		
		if `irace' < 4 {;
			keep if race == `irace';
			local title : word `irace' of `races';
			local label HtM, `title' respondents;
		};
		else {;
			local title all;
			local label "HtM, all households";
		};
		graph bar Wh2m Ph2m [aw=wgt], over(year) stack
			graphregion(color(white))
			legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
			intensity(*0.9)
			lintensity(*0.9)
			ylabel(0(0.1)0.4)
			title("`label'");
		restore;
		cd $basedir/stats/output;
		graph export ${dataset}_h2m_year_`title'.png, replace;
	};
};

////////////////////////////////////////////////////////////////////////////////
#delimit;
if "$dataset"=="SCF" {;
	* h2m by race -- overall;
	gen Nh2m = (h2m == 0);
	replace Nh2m = . if (h2m == .);
	
	forvalues irace = 1/3 {;
		gen Wh2m_race`irace' = Wh2m if race == `irace';
		gen Nh2m_race`irace' = Nh2m if race == `irace';
		gen Ph2m_race`irace' = Ph2m if race == `irace';
	};

	local htm_statuses Wh2m_race Ph2m_race Nh2m_race;
	local labels WHtM PHtM NHtM;
	local tickmaxes 0.3 0.3 0.8;

	forvalues ii = 1/3 {;
		local status : word `ii' of `htm_statuses';
		local label : word `ii' of `labels';
		local tickmax : word `ii' of `tickmaxes';
		
		preserve;
		
		graph bar `status'* [aw=wgt] if year >= 1998, over(year)
			graphregion(color(white))
			legend(label(1 "White") label(2 "Black") label(3 "Hispanic"))
			intensity(*0.9)
			lintensity(*0.9)
			ylabel(0(0.1)`tickmax')
			title("`label'");
		restore;
		cd $basedir/stats/output;
		graph export ${dataset}_year_race_`label'.png, replace;
	};
};

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
