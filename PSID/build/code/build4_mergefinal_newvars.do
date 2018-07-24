#delimit;
clear*;
set maxvar 30000;
cap mkdir $basedir/build/output;

/* Merge of dataset create in build1 with dataset from build3. This script
also creates the relevant variables for HtM computations */;

////////////////////////////////////////////////////////////////////////////////
* MERGE CONSUMPTION AND WEALTH DATA;
cd $basedir/build/temp;
use PSIDwealth.dta;

merge 1:1 intid year using fam1c.dta, update;

////////////////////////////////////////////////////////////////////////////////
* CREATE NEW VARIABLES;
replace	busdebt				= 0 if busdebt == .;
replace	bus					= bus - busdebt;
gen 	liqpos 				= checking;

* gen 	liqneg 				= ccdebt;
gen liqneg					= ccdebt + medicaldebt + legaldebt + studentdebt
								+ famdebt + othdebt;
replace liqneg 				= othdebt if year <= 2009;
gen 	direct 				= stocks;
gen 	nethouses 			= homeequity + othrealestate - othrealestatedebt;
gen 	netcars 			= vehic;
gen 	netbus 				= bus;

gen 	brliqpos 			= liqpos + direct;
* gen 	brliqneg 			= ccdebt;
gen 	brliqneg			= ccdebt + medicaldebt + legaldebt + studentdebt
								+ famdebt + othdebt;
replace brliqneg 			= othdebt if year <= 2009;
gen		netbrliq 			= brliqpos - brliqneg;
gen		brilliqpos 			= nethouses + netcars + othassets + ira;
gen		brilliqneg 			= 0;
gen 	netbrilliq 			= brilliqpos - brilliqneg;
gen		netbrilliqnc 		= netbrilliq - netcars;

gen		netbrliqnstocks 	= netbrliq - stocks;
gen		netbrilliqncstocks	= netbrliqnstocks - netcars;
gen		networthnc			= netbrliq + netbrilliq - netcars;
gen		networthbusnc		= networthnc + netbus;
gen		networthcars		= netbrliq + netbrilliq;
gen		netbrliq2009		= netbrliq - medicaldebt - legaldebt - studentdebt 
								- famdebt;
gen		labinc				= y - asset;
replace	ftax				= 0 if ftax==.;
gen		labinc_post			= labinc - ftax - stax;

////////////////////////////////////////////////////////////////////////////////
* CODE MISSING VALUES;
replace headeduc 	= . if headeduc 	== 99;
replace speduc 		= . if speduc		== 99;
replace state		= . if state		== 99;
replace headrace1	= . if headrace1	== 9;
replace sprace1		= . if sprace1		== 9;
replace age			= . if age			== 999;
replace agew		= . if agew			== 999;


////////////////////////////////////////////////////////////////////////////////
* SAVE;
cd $basedir/build/output;
save PSID.dta, replace;
