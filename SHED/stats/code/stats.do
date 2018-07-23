#delimit;
clear*;
set more 1;
cap mkdir $basedir/stats/output;

/*
This file is where the user indicates which statistics will be computed.
*/;

cd $basedir/build/output;
use SHED.dta;
global dataset SHED;

///////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);

///////////////////////////////////////////////////////////////////////////////
* Unable to pay all bills in full this month;
gen 	paybills_h2m = .;
replace paybills_h2m = 1 if paybills == 0;
replace paybills_h2m = 0 if paybills == 1;
	
* Unable to pay all bills in full this month if there is $400 emergency;
gen 	paybills400_h2m = .;
replace paybills400_h2m = 1 if (paybills == 0) | (paybills400 == 0);
replace paybills400_h2m = 0 if paybills400 == 1;

/* In past 12 months, how frequently have you paid only the min payment on
one or more credit cards? (0=never) (1=once) (2=some of the time)
(3=most or all of the time) */;
gen		ccmin_h2m = .;
replace	ccmin_h2m = 1 if inlist(ccmin,3) & (year > 2014);
replace ccmin_h2m = 0 if inlist(ccmin,0,1,2) & (year > 2014);
	
* Rarely or never have money left over at the end of the month;
gen 	havemoney_h2m = .;
replace havemoney_h2m = 1 if inlist(havemoney,4,5);
replace havemoney_h2m = 0 if inlist(havemoney,1,2,3);
	
* Set aside 3 months of emergency funds ("rainy day funds");
gen 	rainyday_h2m = .;
replace rainyday_h2m = 1 if rainyday==0;
replace rainyday_h2m = 0 if rainyday==1;
	
* Could you cover expenses for 3 months by borrowing, using savings, etc...;
gen 	coverexpenses_h2m = .;
replace coverexpenses_h2m = 1 if coverexpenses==0;
replace coverexpenses_h2m = 0 if coverexpenses==1;

/* In the past month, would you say that your (and your spouse's/and your
partner's income) was...  */;
gen		spendinc_h2m = .;
replace spendinc_h2m = 1 if inlist(spendinc,2,3);
replace	spendinc_h2m = 0 if spendinc == 1;
	
* Could you cover a $400 emergency expense right now?;
gen 	emerg_h2m 	= (emerg_wouldnt==1);
replace emerg_h2m 	= . if (emerg_refused == 1) | (emerg_wouldnt==.);

////////////////////////////////////////////////////////////////////////////////
* COMPUTE H2M BY YEAR;

preserve;
global dataset SHED;
do ${basedir}/../code/yearly_h2m.do;
save ${basedir}/stats/output/SHED_h2mstat, replace;
restore;

////////////////////////////////////////////////////////////////////////////////
* DISPLAY RESULTS IN COMMAND WINDOW;
use ${basedir}/stats/output/SHED_h2mstat.dta, clear;
keep year *_h2m;
rename paybills_h2m 		paybills;
rename paybills400_h2m 		paybills400;
rename ccmin_h2m 			ccmin;
rename havemoney_h2m 		havemoney;
rename rainyday_h2m 		rainyday;
rename coverexpenses_h2m 	cover3mos;
rename spendinc_h2m 		spendinc;
rename emerg_h2m 			emerg400;
li	year paybills	paybills400	ccmin			spendinc, clean noobs;
li	year havemoney	rainyday	cover3mos	emerg400, clean noobs;
