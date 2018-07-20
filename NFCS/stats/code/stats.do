#delimit;
clear*;
set more 1;
cap mkdir $basedir/stats/output;

/* Computes statistics from NFCS */;

////////////////////////////////////////////////////////////////////////////////
cd $basedir/build/output;
use NFCS.dta;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;

drop if year == 2009;
drop if inlist(agegrp,1,6); /* Use ages 25-64 */;

////////////////////////////////////////////////////////////////////////////////
* Financial fragility;
preserve;
collapse (mean) get2000certain (mean) get2000probably (mean) get2000probablynot
	(mean) get2000not [aw=wgt], by(year);
cd $basedir/stats/output;
save NFCS_get2000.dta, replace;
restore;

* H2m stats;
/* Over the past year, would you say your household's spending was less than, 
more than, or about equal to your household's income? Please do not include the 
purchase of a new house or car, or other big investments you may have
made. */;
gen		h2m_spendinc = .;
replace h2m_spendinc = 1 if inlist(spendinc,2,3); 	/* More than or equal to */;
replace h2m_spendinc = 0 if spendinc == 1; 			/* Less than */

/* In a typical month, how difficult is it for you to cover your expenses and 
pay all your bills? */;
gen 	h2m_paybills = .;
replace h2m_paybills = 1 if paybills == 1; /* Very difficult */;
replace h2m_paybills = 0 if inlist(paybills,2,3); /* Somewhat/not at all diff */;

/* Have you set aside emergency or rainy day funds that would cover your expenses 
for 3 months, in case of sickness, job loss, economic downturn, or other 
emergencies? */;
gen 	h2m_rainyday = .;
replace h2m_rainyday = 1 if rainyday == 2;
replace h2m_rainyday = 0 if rainyday == 1;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;
cd $basedir/stats/code;
do stats_plots.do;
