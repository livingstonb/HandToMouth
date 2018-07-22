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
* h2m by year;
preserve;
graph bar Wh2m Ph2m [aw=wgt], over(year) stack
	graphregion(color(white))
	legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
	intensity(*0.9)
	lintensity(*0.9);
restore;
cd $basedir/stats/output;
graph export ${dataset}_h2m_year.png, replace;
