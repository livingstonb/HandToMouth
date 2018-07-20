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
* STATISTICS;

* Financial fragility;
preserve;
collapse (mean) get2000certain (mean) get2000probably (mean) get2000probablynot
	(mean) get2000not [aw=wgt], by(year);
save ${basedir}/stats/output/NFCS_get2000.dta, replace;
restore;

* H2m stats;
/* Over the past year, would you say your household's spending was less than, 
more than, or about equal to your household's income? Please do not include the 
purchase of a new house or car, or other big investments you may have
made. */;
gen		spendinc_h2m = .;
replace spendinc_h2m = 1 if inlist(spendinc,2,3); 	/* More than or equal to */;
replace spendinc_h2m = 0 if spendinc == 1; 			/* Less than */

/* In a typical month, how difficult is it for you to cover your expenses and 
pay all your bills? */;
gen 	paybills_h2m = .;
replace paybills_h2m = 1 if paybills == 1; /* Very difficult */;
replace paybills_h2m = 0 if inlist(paybills,2,3); /* Somewhat/not at all diff */;

/* Have you set aside emergency or rainy day funds that would cover your expenses 
for 3 months, in case of sickness, job loss, economic downturn, or other 
emergencies? */;
gen 	rainyday_h2m = .;
replace rainyday_h2m = 1 if rainyday == 2;
replace rainyday_h2m = 0 if rainyday == 1;

/* Households which do not have rainy day funds and could probably not or could
not come up with $2000 */;
gen		rainydayXget2000_h2m = .;
replace rainydayXget2000_h2m = 1 if (rainyday_h2m==1) & (get2000bottom==1);
replace rainydayXget2000_h2m = 0 if (rainyday_h2m==0) | (get2000bottom==0);

////////////////////////////////////////////////////////////////////////////////
* COMPUTE H2M BY YEAR;

preserve;
do ${basedir}/../code/yearly_h2m.do;
save ${basedir}/stats/output/NFCS_h2mstat, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;
do ${basedir}/stats/code/stats_plots.do;
