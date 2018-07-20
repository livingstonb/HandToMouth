#delimit;
clear*;


cd $BaseDir;
use htm_psid_allyears;
replace liqvar = liqvar + stocks;
gen clim = 1;
gen payfreq = 2;
global borrowlimtype normal;
global h2mtype normal;
gen incvar = labinc;

* SAMPLE SELECTION
keep if age >= 25 & age <= 55;


cd $BaseDir/../code;
do compute_h2m.do;
collapse (mean) h2m Wh2m Ph2m NWh2m [aw=wgt], by(year);
