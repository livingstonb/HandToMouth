#delimit;
set more 1;

/* This do-file produces plots for GALLUP US Daily when called by stats.do */;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

* Bar chart;
graph bar h2m_majorpurchase h2m_affordneeds [aw=wgt], over(incomenarrow)
	legend(label(1 "Would not be able to make a major purchase right now")
		label(2 "Cannot afford to buy the things I need") cols(1))
	intensity(*0.9)
	lintensity(*0.9)
	graphregion(color(white));
		   
cd $basedir/stats/output;
graph export GALLUPbar.png, replace;

* Population shares corresponding with the above bar chart;
preserve;
collapse (firstnm) pop_incshare, by(incomenarrow);
graph bar pop_incshare, over(incomenarrow, label(angle(0)))
	ytitle("Population shares")
	intensity(*0.9)
	lintensity(*0.9)
	graphregion(color(white));
restore;
		   
cd $basedir/stats/output;
graph export GALLUPpopshare.png, replace;

* Time plot of majorpurchase;
preserve;
gen timeindex = dofm(monthdate);
gen firstdate = date("07/01/2009","MDY");
gen lastdate = date("12/01/2017", "MDY");
keep if (timeindex >= firstdate) & (timeindex < lastdate); 

collapse (mean) h2m_majorpurchase h2m_affordneeds [aw=dailywgt], by(monthdate);

local X ;
forvalues i = 2009(2)2017 {;
	local x = tm(`i'm1);
	local X `X' `x';
};
twoway line h2m_affordneeds h2m_majorpurchase monthdate,
	xtitle("Period") ytitle("Unable to make a major purchase")
	graphregion(color(white))
	tscale(range(`X'))
	tlabel(`X')
	legend(label(1 "Unable to afford the things I need")
	label(2 "Unable to make a major purchase right now"))
	legend(cols(1));

cd $basedir/stats/output;
graph export GALLUPmajorpurchase.png, replace;
restore;
