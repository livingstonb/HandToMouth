#delimit;
clear*;
set more 1;
capture mkdir $basedir/stats/output;

/* This is the main do-file for computing statistics for the GALLUP US Daily */;

////////////////////////////////////////////////////////////////////////////////
cd $basedir/build/output;
use GALLUP.dta;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
drop if (age < 25) | (age > 65);

////////////////////////////////////////////////////////////////////////////////
* QUESTIONS/H2M DEFINITIONS;
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

* Save mean h2m statistics;
preserve;
collapse (mean) h2m* [aw=wgt];
cd $basedir/stats/output;
save h2mstat.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

cd $basedir/stats/code;
do stats_plots.do;