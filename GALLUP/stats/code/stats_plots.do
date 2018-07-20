#delimit;
set more 1;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

* Bar chart;
graph bar h2m_majorpurchase h2m_affordneeds [aw=wgt], over(incomenarrow)
	legend(label(1 "Would not be able to make a major purchase right now")
		label(2 "Cannot afford to buy the things I need") cols(1))
	graphregion(color(white));
		   
cd $basedir/stats/output;
graph export GALLUPbar.png, replace;

* Time plot of majorpurchase;
preserve;
collapse (mean) h2m_majorpurchase [aw=wgt], by(monthdate);
twoway line h2m_majorpurchase monthdate,
	xtitle("Month") ytitle("Fraction unable to make a major purchase")
	graphregion(color(white));

cd $basedir/stats/output;
graph export GALLUP_majorpurchase.png, replace;
restore;
