#delimit;
set more 1;

////////////////////////////////////////////////////////////////////////////////
* PLOTS;
* Bar char split by income;
preserve;
graph bar get2000not get2000probablynot get2000probably get2000certain [aw=wgt],
	stack over(year)
	legend(label(1 "Could not come up with $2000") 
	label(2 "Could probably not come up with $2000") 
	label(3 "Could probably come up with $2000")
	label(4 "Could certainly come up with $2000"))
	legend(cols(1))
	legend(order(4 3 2 1))
	intensity(*0.7)
	lintensity(*0.7)
	graphregion(color(white));
restore;
cd $basedir/stats/output;
graph export NFCS_h2m_bar.png, replace;

* Bar char split by impatience;
