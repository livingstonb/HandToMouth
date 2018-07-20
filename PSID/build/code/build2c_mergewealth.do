#delimit;
clear*;
set maxvar 30000;

cd $BaseDir/build/temp;
use PSID_wealth1.dta;
merge 1:1 intid year using PSID_wealth2.dta, update nogen;

merge 1:1 intid year using fam1b.dta, update nogen;

cd $BaseDir/build/temp;
save fam1c.dta, replace;
