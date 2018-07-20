#delimit;
preserve;
collapse (mean) h2m (mean) Wh2m (mean) Ph2m (mean) NWh2m [aw=wgt], by(age);
sort age;
graph twoway line Ph2m age, lpattern(dash)
	|| line Wh2m age, lpattern(solid)
	graphregion(color(white))
	legend(label(1 "Poor Hand-to-Mouth") label(2 "Wealthy Hand-to-Mouth")
	cols(1) region(lcolor(white))) xtitle("Age");
restore;
