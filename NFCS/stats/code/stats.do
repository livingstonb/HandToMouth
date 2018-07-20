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
* H2m Stats;
preserve;
collapse (mean) get2000certain (mean) get2000probably (mean) get2000probablynot
	(mean) get2000not [aw=wgt], by(year);

* save;
cd $basedir/stats/output;
save NFCS_stats.dta, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;
cd $basedir/stats/code;
do stats_plots.do;
