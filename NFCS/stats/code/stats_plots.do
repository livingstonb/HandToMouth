#delimit;
set more 1;

/* This do-file makes plots from NFCS data when called by stats.do */;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;
* Bar char grouped by income;
preserve;
graph bar get2000not get2000probablynot get2000probably get2000certain if year > 2009 [aw=wgt],
	stack over(year)
	legend(label(1 "Could not come up with $2000") 
	label(2 "Could probably not come up with $2000") 
	label(3 "Could probably come up with $2000")
	label(4 "Could certainly come up with $2000"))
	legend(cols(1))
	legend(order(4 3 2 1))
	intensity(*0.9)
	lintensity(*0.9)
	graphregion(color(white));
restore;
cd $basedir/stats/output;
graph export NFCS_h2m_barincome.png, replace;


* Bar char grouped by impatience;
preserve;
graph bar get2000bottom get2000top [aw=wgt],
	stack 
	over(timediscount, relabel(1 "Most impatient" 2" " 3" " 4" " 5 "Most patient"))
	legend(label(1 "Could probably not or certainly not come up with $2000")
	label(2 "Could probably or certainly come up with $2000"))
	legend(cols(1))
	legend(order(4 3 2 1))
	intensity(*0.9)
	lintensity(*0.9)
	graphregion(color(white));
restore;
cd $basedir/stats/output;
graph export NFCS_h2m_bartimed.png, replace;
