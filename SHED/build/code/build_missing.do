#delimit; 
clear;
set more 1;

/* Codes missing values */;

///////////////////////////////////////////////////////////////////////////////;
cd $basedir/build/temp;
use SHED_temp.dta;

local codevars havemoney mortpmt savaut ccmin behindstudpmts
	rettrack retsavings borrowret inccat billstruggle spendinc 
	retired educ studdebt rainyday coverexpenses paybills paybills400 
	delinq_rentmort delinq_cc delinq_util
	delinq_phonecable delinq_car delinq_studloan delinq_other skip_rentmort 
	skip_cc skip_util skip_phonecable skip_car skip_studloan skip_other
	notafford_med notafford_doc notafford_mentcare notafford_dental 
	notafford_specialist notafford_followup
	educmother educfather hispanic spanish age agecat
	educ2 educ2cat race gender hhhead hhsize hhincome marital region4 region9
	state working occupation industry physhealth savings finlit1 finlit2
	finlit3 finlit4 finlit5;
foreach codevar of local codevars {;
	replace `codevar' = . if inlist(`codevar',-9,-2,-1);
};

///////////////////////////////////////////////////////////////////////////////;
cd $basedir/build/output;
save SHED.dta, replace;
