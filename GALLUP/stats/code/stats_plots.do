#delimit;
clear*;
set more 1;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

graph bar h2m_majorpurchase h2m_affordneeds, over(incomenarrow)
	legend(label(1 "Would not be able to make a major purchase right now")
		label(2 "Cannot afford to buy the things I need") cols(1))
	graphregion(color(white));
		   
cd $basedir/stats/output;
graph export GALLUPbar.png, replace;
