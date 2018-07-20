#delimit;

/* This do-file plots h2m by year */;

preserve;
graph bar Wh2m Ph2m [aw=wgt], over(year) stack
	graphregion(color(white))
	legend(label(1 "Wealthy Hand-to-Mouth") label(2 "Poor Hand-to-Mouth"))
	intensity(*0.9)
	lintensity(*0.9);
restore;
