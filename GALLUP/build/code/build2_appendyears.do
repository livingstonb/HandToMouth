#delimit;

/* This do-file appends years and performs data cleaning */;

////////////////////////////////////////////////////////////////////////////////
clear*;
set more 1;
cap mkdir $basedir/build/output;

////////////////////////////////////////////////////////////////////////////////
* APPEND YEARS;
cd $basedir/build/temp;
use US_DAILY_2008_DATA_cleaned;	
forvalues yr=2009(1)2017 {;
	append using US_DAILY_`yr'_DATA_cleaned;
};

////////////////////////////////////////////////////////////////////////////////
* ENFORCE MISSING VALUES;

local missing34 hispanic buyfood buyshelter buymedicine majorpurchase cuttingback
	morethanenoughmoney affordneeds;
foreach missvar of local missing34 {;
	replace `missvar' = . if inlist(`missvar',3,4);
};

replace married 			= . if inlist(married,6,7);
replace income				= . if inlist(income,98,99);
replace children			= . if inlist(children,98,99);
replace moneyforeverything 	= . if inlist(moneyforeverything,8,9);
replace educ 				= . if inlist(educ,7,8);
replace workcat				= . if inlist(workcat,13,14);
replace age					= . if age == 100;

////////////////////////////////////////////////////////////////////////////////
* CREATE NEW VARIABLES;
gen incomenarrow 	 = 1 if inlist(income,1,2,3,4);
replace incomenarrow = 2 if inlist(income,5,6,7);
replace incomenarrow = 3 if inlist(income,8,9);
replace incomenarrow = 4 if inlist(income,10);

label define incomenarrow 1 "Less than $24,000" 2 "$24,000 - $59,999"
	3 "$60,000 - $119,999" 4 "$120,000 and over";
label values incomenarrow incomenarrow;

format 	INT_DATE 		%td;
gen 	monthdate 		= mofd(INT_DATE);
format 	monthdate 		%tm;
rename 	MOTHERLODE_ID 	id;


/* Normalize weights since sums are dramatically different depending on year */;
bysort INT_DATE: egen dwgtsum = sum(dailywgt);
replace dailywgt = dailywgt/dwgtsum;
bysort year: egen MSAsum = sum(MSAwgt);
replace MSAwgt = MSAwgt/MSAsum;


////////////////////////////////////////////////////////////////////////////////
* SAVE AND REMOVE TEMP FILES;

cd $basedir/build/output;
save GALLUP.dta, replace;

cd $basedir/build/temp;
forvalues yr=2008(1)2017 {;
	rm US_DAILY_`yr'_DATA_cleaned.dta;
};
