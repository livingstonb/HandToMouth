#delimit;
clear;
set more 1;
cap mkdir $basedir/build/temp;

/* Builds the SHED.dta dataset for computing hand-to-mouth statistics.
SHEDXXXX.dta datasets must be placed in SHED/build/input */;

///////////////////////////////////////////////////////////////////////////////
* APPEND YEARS;
cd $basedir/build/input;
use SHED2013.dta;
gen year = 2013;
append using SHED2014.dta;
replace year = 2014 if year == .;
append using SHED2015.dta;
replace year = 2015 if year == .;
append using SHED2016.dta;
replace year = 2016 if year == .;
append using SHED2017.dta;
replace year = 2017 if year == .;

rename weight3b wgt;
replace wgt = weight3 if year == 2014;
replace wgt = weight if year == 2013;
/* Normalize weights since sums are dramatically different depending on year */;
bysort year: egen wgtsum = sum(wgt);
replace wgt = wgt/wgtsum;
////////////////////////////////////////////////////////////////////////////////
* RENAME VARIABLES;
* Make sure to add any new variables to missing.do to clean missing values!;
rename 	B1_a 	havemoney;
replace havemoney = . if year == 2013;
rename 	M4 		mortpmt;
rename 	FM10_f 	savaut;
rename 	C4B 	ccmin;
rename 	SL6 	behindstudpmts;
rename 	K0 		rettrack;
rename 	K20 	retsavings;
rename 	DC4 	finlit;
rename 	K5A 	borrowret;
rename 	I40 	inccat;
rename 	I12 	billstruggle;
rename 	I20 	spendinc;
replace spendinc = I1 if inlist(year,2013,2014,2015,2016);
rename 	ED0 	educ;
rename 	SL1 	studdebt;
rename 	EF1 	rainyday;
replace rainyday = E1B if inlist(year,2013,2014);
rename 	EF2 	coverexpenses;
replace coverexpenses = E1A if inlist(year,2013,2014);

* $400 emergency expense;
rename 	EF3_a 		emerg_ccfull;
rename 	EF3_b 		emerg_cctime;
rename 	EF3_c 		emerg_cash;
rename 	EF3_d 		emerg_loan;
rename 	EF3_e 		emerg_friend;
rename 	EF3_f 		emerg_paydayetc;
rename 	EF3_g 		emerg_sell;
rename 	EF3_h 		emerg_wouldnt;
rename 	EF3_i 		emerg_other ;
rename 	EF3_Refused	emerg_refused;
replace emerg_ccfull  	= E3A_a			if year == 2014;
replace emerg_cctime  	= E3A_b			if year == 2014;
replace emerg_cash		= E3A_c			if year == 2014;
replace emerg_loan		= E3A_d			if year == 2014;
replace	emerg_friend	= E3A_e			if year == 2014;
replace emerg_paydayetc	= E3A_f			if year == 2014;
replace emerg_sell		= E3A_g			if year == 2014;
replace emerg_wouldnt 	= E3A_h			if year == 2014;
replace	emerg_other		= E3A_i			if year == 2014;
replace	emerg_refused 	= E3A_Refused 	if year == 2014;
replace emerg_ccfull  	= E3B_a			if year == 2013;
replace emerg_cctime  	= E3B_b			if year == 2013;
replace emerg_cash		= E3B_c			if year == 2013;
replace emerg_loan		= E3B_d			if year == 2013;
replace	emerg_friend	= E3B_e			if year == 2013;
replace emerg_paydayetc	= E3B_f			if year == 2013;
replace emerg_sell		= E3B_g			if year == 2013;
replace emerg_wouldnt 	= E3B_h			if year == 2013;
replace	emerg_other		= E3B_i			if year == 2013;
replace	emerg_refused 	= E3B_Refused 	if year == 2013;

* able to pay all bills this month;
rename EF5A paybills;
* able to pay all bills even with a $400 emergency expense;
rename EF5B paybills400;

* delinquent on bills;
rename EF6A_a delinq_rentmort;
rename EF6A_b delinq_cc;
rename EF6A_c delinq_util;
rename EF6A_d delinq_phonecable;
rename EF6A_e delinq_car;
rename EF6A_f delinq_studloan;
rename EF6A_g delinq_other;
rename EF6B_a skip_rentmort;
rename EF6B_b skip_cc;
rename EF6B_c skip_util;
rename EF6B_d skip_phonecable;
rename EF6B_e skip_car;
rename EF6B_f skip_studloan;
rename EF6B_g skip_other;

* couldn’t afford to make a necessary expenditure;
rename E1_a notafford_med;
rename E1_b notafford_doc;
rename E1_c notafford_mentcare;
rename E1_d notafford_dental;
rename E1_e notafford_specialist;
rename E1_f notafford_followup;

* demographics and other variables;
rename CH2 			educmother;
rename CH3 			educfather;
rename FL1 			finlit1;
rename FL2 			finlit2;
rename FL3 			finlit3;
rename FL4 			finlit4;
rename FL5 			finlit5;
rename xhispan 		hispanic;
rename xspanish 	spanish;
rename ppage 		age;
rename ppagecat 	agecat;
rename ppeduc 		educ2;
rename ppeducat 	educ2cat;
rename ppethm 		race;
rename ppgender 	gender;
rename pphhhead 	hhhead;
rename pphhsize 	hhsize;
rename ppincimp 	hhincome;
rename ppmarit		marital;
rename ppreg 		region4;
rename ppreg9 		region9;
rename ppstaten 	state;
rename ppwork 		working;
rename ppcm0160 	occupation;
rename IND1 		industry;
rename pph10001 	physhealth;
rename ppfs0596 	savings;

* generate variables;
gen retired = 1 if working == 5;

////////////////////////////////////////////////////////////////////////////////
* SAVE;
cd $basedir/build/temp;
save SHED_temp.dta, replace;
