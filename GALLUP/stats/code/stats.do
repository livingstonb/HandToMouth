#delimit;
clear*;
set more 1;
capture mkdir $basedir/stats/output;

////////////////////////////////////////////////////////////////////////////////
cd $basedir/build/output;
use GALLUP.dta;

///////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
drop if (age < 25) | (age > 65);

///////////////////////////////////////////////////////////////////////////////
/* Would you be able right now to make a major purchase, such as a car, 
appliance, or furniture, or pay for a significant home repair if you 
needed to? */;
gen h2m_majorpurchase = .;
replace h2m_majorpurchase = 1 if majorpurchase == 2;
replace h2m_majorpurchase = 0 if majorpurchase == 1;

/* Do you have enough money to buy the things you need, or not? */;
gen h2m_affordneeds = .;
replace h2m_affordneeds = 1 if affordneeds == 2;
replace h2m_affordneeds = 0 if affordneeds == 1;

collapse (mean) h2m_majorpurchase (mean) h2m_affordneeds [aw=wgt], by(incomenarrow);

cd $basedir/stats/output;
save h2mstat.dta, replace;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

graph bar h2m_majorpurchase h2m_affordneeds, over(incomenarrow)
	legend(label(1 "Would not be able to make a major purchase right now")
		label(2 "Cannot afford to buy the things I need") cols(1))
	graphregion(color(white));
		   
cd $basedir/stats/output;
graph export GALLUPbar.png, replace;
