#delimit;
clear*;
set more 1;
cap mkdir ${basedir}/build/output;

////////////////////////////////////////////////////////////////////////////////
* CLEAN;

use ${basedir}/build/temp/fmli_allyears, clear;

* CU characteristics;
gen		id 			= newid;
gen		age			= age_ref;
gen		agesp		= age2;
gen		housetenure	= cutenure;
gen		educ		= educ_ref;
gen		educsp		= educa2;
gen		famsize		= fam_size;	
gen		intmonth	= qintrvmo;		/* - */;
gen		intyear		= qintrvyr;		/* - */;
gen		race1		= ref_race;		/* - */;
gen		sex			= sex_ref;		/* - */;
* race2 	= race2; 	/* - */;
* sex2		= sex2;		/* - */;
* region 	= region 	/* -*/;

* Create datetime variable;
gen qdate = string(year) + " Q" + string(q);
gen YQ = quarterly(qdate,"YQ");
format YQ %tq;
tsset id YQ;


* Wealth variables;
gen		ccdebt		= .;				
replace	ccdebt		= 0 	if creditb=="1";			/* 2013q2- */;
replace	ccdebt		= 500 	if creditb=="2";
replace ccdebt		= 1000 	if creditb=="3";
replace ccdebt		= 2500 	if creditb=="4";
replace ccdebt		= 10000 if creditb=="5";
replace ccdebt		= 35000 if creditb=="6";
replace ccdebt		= creditx if creditx < .; 	/* 2013q2- */;
gen 	checking	= ckbkactx; 				/* -2013q1 */;
replace checking 	= liquidx if checking==.; 	/* 2013q2- */;
replace	checking	= 500	if liquidb=="1";		/* 2013q2- */;
replace checking	= 1000	if liquidb=="2";
replace checking	= 2500 	if liquidb=="3";
replace checking	= 10000 if liquidb=="4";
replace checking	= 35000 if inlist(liquidb,"5","6");
gen		saving		= savacctx; 				/* -2013q1 */;
* saving included in liquidx for 2013q2-;
replace	saving		= 0 if (YQ >= quarterly("2013 Q2","YQ")) & (checking<.);
gen		stocks		= secestx;					/* -2013q1 */; 
replace	stocks		= stockx if stocks==.;	 	/* 2013q2- */;
replace	stocks		= 0		 if stockb=="1";		/* 2013q2- */;
replace	stocks		= 2000	 if stockb=="2";
replace stocks		= 10000	 if stockb=="3";
replace stocks		= 50000	 if stockb=="4";
replace stocks		= 200000 if stockb=="5";
replace	stocks		= 450000 if stockb=="6";
gen		studentdebt = studntx; 					/* 2013q2- */;
gen		retacc		= irax;						/* 2013q2- */;
gen		othassets	= othastx;					/* 2013q2- */;
gen		othdebt		= othlonx;					/* 2013q2- */;
gen		savbond		= usbndx;					/* 1996q1-2013q1 */;

* Don't know;
gen		pension		= fpripenx;					/* -2004q1,2006q1- */;
replace	pension		= fpripenm if pension==.;	/* 2004q1- */;



* Income variables;
gen		income_post		= finatxem;				/* 20013q2- */;
gen		income_pre		= fincbtxm;				/* 2004q1- */;
gen		wages			= fsalaryx;				/* -2004q1,2006q1- */;
replace	wages			= fsalarym 	if wages==.;	/* 2004q1- */;
gen		farm			= ffrmincx;				/* -2004q1,2006q1-2013q1 */;
replace	farm			= ffrmincm 	if farm==.;	/* 2004q1-2013q1 */;
gen		bus				= fnonfrmx;				/* -2004q1,2006q1- */;
replace	bus				= fnonfrmm 	if bus==.;	/* 2004q1-2013q1 */;
gen		selfearn		= fsmpfrxm;				/* 2013q2- */;
gen		rentinc			= inclossa;				/* -2004q1,2006q1- */;
replace	rentinc			= inclosam 	if rentinc==.;	/* 2004q1-2013q1 */;
replace	rentinc			= netrentm 	if rentinc==.;	/* 2013q2- */;
gen		savint			= intearnx;				/* -2004q1,2006q1- */;
replace	savint			= intearnm 	if savint==.;	/* 2004q1-2013q1 */;
gen 	int_and_div		= intrdvxm;				/*	2013q1- */;
gen		lumpsumtrust	= lumpsumx; 			/* 	-2013q1 */;
gen		dividtrust		= finincxm;				/* 2004q1-2013q1 */;
gen		royalttrust		= royestxm;				/* 2013q1- */;
gen		alimony			= aliothxm; 			/* 2004q1-2013q1 */;
gen		childsupp		= chdlmpx;				/* 	-2013q1 */;
gen		othchildsupp	= chdothxm;				/* 	-2004q1,2006q1-2013q1 */;
gen		workcomp		= compensm;				/* 2004q1-2013q1 */;
gen		foodstamps		= foodsmpx;				/* 2001q2-2004q1,2006q1-2013q1 */;
replace	foodstamps		= foodsmpm 	if foodstamps==.;	/* 2004q1-2013q1 */;
gen 	socsec			= frretirx;				/* -2004q1,2006q1- */;
replace	socsec			= frretirm 	if socsec==.;		/* 2004q1- */;
gen		ssi				= fssix;				/* -2004q1,2006q1- */;
replace	ssi				= fssixm 	if ssi==.;		/* 2004q1- */;
gen		othinc			= othregxm;				/* 2013q2- */;
gen		othinc2			= othrincx;				/* -2004q1,2006q1- */;
replace	othinc2			= othrincm 	if othinc2==.;		/* 2004q1- */;
gen		pensioninc		= pensionx;				/* -2004q1,2006q1- */;
replace	pensioninc		= pensionm 	if pensionx==.;		/* 2004q1-2013q1 */;
gen		retsurvivor		= retsurvm;				/* 2013q2- */;
gen		saleshousehold	= saleincx;				/* - 2013q1 */;
gen		uiben			= unemplx;				/* -2004q1,2006q1-2013q1 */; 
replace	uiben			= unemplxm if uiben==.;	/* 2004q1-2013q1 */;
gen		localwelf		= welfarex;				/* -2004q1,2006q1- */;
replace	localwelf		= welfarem if localwelf--.; /* 2004q1- */;

* Tax variables;
gen		feddeducted		= famtfedx;				/* -2004q1,2006q1-2015q1 */;
replace	feddeducted		= famtfedm 	if feddeducted==.;	/* 2004q1-2015q1 */;
gen		fedrefund		= fedr_ndx				/* -2015q1 */;
gen		proptax			= proptxcq*4;			/* - */;
gen		othproptax		= taxpropx;				/* -2013q1 */;
gen		salt			= sloctaxx;				/* -2015q1 */;	
replace	salt			= fsltaxx 	if salt==.;	/* -2004q1,2006q1-2015q1 */;
replace	salt			= fsltaxxm 	if salt==.;	/* 2004q1-2015q1 */;
gen		saltrefund		= slrfundx;				/* -2015q1 */;
gen		totalptax		= tottxpdx;				/* -2004q1,2006q1-2014q1 */;
replace	totalptax		= tottxpdm if totalptax==.; /* 2004q1-2014q5 */;

* Consumption;
gen		totalexp		= totex4cq*4;

* Other;
gen		incrank			= inc_rnkm;				/* 2004q1- */;
gen		poverty			= pov_cym;				/* 2004q1-2014q1 */;
gen		wgt				= finlwt21;				/* - */;

////////////////////////////////////////////////////////////////////////////////
* REPLACE MISSING WITH ZEROS;
local zeros ccdebt stocks saving farm bus;
foreach zero of local zeros {;
	replace `zero' = 0 if `zero'==.;
};


////////////////////////////////////////////////////////////////////////////////
* MULTIPLE IMPUTATIONS;
gen obsid = _n;
expand 5;
gen imps = 0;
bysort obsid: replace imps = _n;
local impvars finatxe fincbtx fsalary ffrminc fnonfrm
	fsmpfrx inclosa netrent intearn intrdvx finincx royestx aliothx
	chdothx compens foodsmp frretir fssix othregx othrinc pension retsurv
	unemplx welfare famtfed fsltaxx tottxpd inc_rnk;
foreach impvar of local impvars {;
	di "`impvar'";
	gen `impvar'_imp = .;
	forvalues i=1/5 {;
		replace `impvar'_imp = `impvar'`i' if imps==`i';
	};
};

rename finatxe_imp income_post_imp;
rename fincbtx_imp income_pre_imp;
rename imps reps;

forvalues i= 1/44{;
	if `i' < 10 {;
		rename wtrep0`i' wt1b`i';
	};
	else {;
		rename wtrep`i' wt1b`i';
	};
};
forvalues i=44(-1)1 {;
	gen mm`i' = 1;
};

////////////////////////////////////////////////////////////////////////////////
* DEFINE NEW VARIABLES;

gen 	brliqpos 		= checking + saving + stocks;
gen 	brliqneg 		= ccdebt;
gen		netbrliq 		= brliqpos - brliqneg;

////////////////////////////////////////////////////////////////////////////////
* KEEP ONLY NECESSARY VARIABLES (multiple imputations create very large dataset);
keep year age wt* mm* reps income_post netbrliq wgt income_pre totalexp YQ
	selfearn checking wages income_post_imp income_pre_imp;


////////////////////////////////////////////////////////////////////////////////
* SAVE;
save ${basedir}/build/output/CEXfmli, replace;
