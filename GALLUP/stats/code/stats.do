#delimit;
clear*;
set more 1;
capture mkdir $basedir/stats/output;

/* This is the main do-file for computing statistics for the GALLUP US Daily */;

/* Output:
	question responses, mean over years	- GALLUPh2m.dta
*/;

////////////////////////////////////////////////////////////////////////////////
cd $basedir/build/output;
use GALLUP.dta;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE/WEIGHT SELECTION;
keep if (age >= 25) | (age <= 79);

rename MSAwgt wgt;

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

/* Have there been times in the past twelve months when you did not have enough
money to buy the food that your family needed? */
gen h2m_buyfood = .;
replace h2m_buyfood = 1 if buyfood == 1;
replace h2m_buyfood = 0 if buyfood == 2;

/* Have there been times in the past twelve months when you did not have enough
money to [afford shelter]? (asked in 2008-2013 surveys)*/
gen h2m_buyshelter = .;
replace h2m_buyshelter = 1 if buyshelter == 1;
replace h2m_buyshelter = 0 if buyshelter == 2;

/* Have there been times in the past twelve months when you did not have enough
money to pay for health care and/or medicines that your or your family needed? 
(asked in 2008-2016 surveys)*/;
gen h2m_buymedicine = .;
replace h2m_buymedicine = 1 if buymedicine == 1;
replace h2m_buymedicine = 0 if buymedicine == 2;

* Save mean h2m statistics;
preserve;
collapse (mean) h2m* [aw=wgt];
cd $basedir/stats/output;
save GALLUPh2m.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;

cd $basedir/stats/code;
do stats_plots.do;

////////////////////////////////////////////////////////////////////////////////
* DISPLAY RESULTS IN COMMAND WINDOW;
use ${basedir}/stats/output/GALLUPh2m.dta, clear;
foreach h2mvar of varlist h2m* {;
	di "`h2mvar' = " `h2mvar';
};
