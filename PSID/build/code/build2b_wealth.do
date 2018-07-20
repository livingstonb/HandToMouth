#delimit;
clear*;
set maxvar 30000;

/* Appends wealth datasets by year and performs basic data cleaning */;

////////////////////////////////////////////////////////////////////////////////
* APPEND BY YEAR;
cd $basedir/build/input;
use wlth1999/wlth1999.dta;
gen year = 1999;
forvalues yrind = 2001(2)2007 {;
	append using wlth`yrind'/wlth`yrind'.dta;
	replace year = `yrind' if year == .;
};

* Family ID;
gen intid = S801 if year == 2007;
replace intid = S701 if year == 2005;
replace intid = S601 if year == 2003;
replace intid = S501 if year == 2001;
replace intid = S401 if year == 1999;

////////////////////////////////////////////////////////////////////////////////
* WEALTH VARIABLES;
gen checking = S805 if year == 2007;
replace checking = S705 if year == 2005;
replace checking = S605 if year == 2003;
replace checking = S505 if year == 2001;
replace checking = S405 if year == 1999;

gen othrealestate = S809 if year == 2007;
replace othrealestate = S709 if year == 2005;
replace othrealestate = S609 if year == 2003;
replace othrealestate = S509 if year == 2001;
replace othrealestate = S409 if year == 1999;

gen stocks = S811 if year == 2007;
replace stocks = S711 if year == 2005;
replace stocks = S611 if year == 2003;
replace stocks = S511 if year == 2001;
replace stocks = S411 if year == 1999;

gen vehic = S813 if year == 2007;
replace vehic = S713 if year == 2005;
replace vehic = S613 if year == 2003;
replace vehic = S513 if year == 2001;
replace vehic = S413 if year == 1999;

gen othassets = S815 if year == 2007;
replace othassets = S715 if year == 2005;
replace othassets = S615 if year == 2003;
replace othassets = S515 if year == 2001;
replace othassets = S415 if year == 1999;

gen othdebt = S807 if year == 2007;
replace othdebt = S707 if year == 2005;
replace othdebt = S607 if year == 2003;
replace othdebt = S507 if year == 2001;
replace othdebt = S407 if year == 1999;

gen ira = S819 if year == 2007;
replace ira = S719 if year == 2005;
replace ira = S619 if year == 2003;
replace ira = S519 if year == 2001;
replace ira = S419 if year == 1999;

gen homeequity = S820 if year == 2007;
replace homeequity = S720 if year == 2005;
replace homeequity = S620 if year == 2003;
replace homeequity = S520 if year == 2001;
replace homeequity = S420 if year == 1999;

gen networth = S817 if year == 2007;
replace networth = S717 if year == 2005;
replace networth = S617 if year == 2003;
replace networth = S517 if year == 2001;
replace networth = S417 if year == 1999;

gen networthnohomeequity = S816 if year == 2007;
replace networthnohomeequity = S716 if year == 2005;
replace networthnohomeequity = S616 if year == 2003;
replace networthnohomeequity = S516 if year == 2001;
replace networthnohomeequity = S416 if year == 1999;

* drop unnecessary variables;
keep intid year checking othrealestate stocks vehic othassets ira homeequity 
	networth networthnohomeequity othdebt;

////////////////////////////////////////////////////////////////////////////////
* SAVE;
cd $basedir/build/temp;
save PSID_wealth2.dta, replace;

