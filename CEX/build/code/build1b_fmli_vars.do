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
gen		ccdebt		= creditx;					/* 2013q2- */;
gen 	checking	= ckbkactx; 				/* -2013q1 */;
replace checking 	= liquidx if checking==.; 	/* 2013q2- */;
gen		saving		= savacctx; 				/* -2013q1 */;
* saving included in liquidx for 2013q2-;
replace	saving		= 0 if (YQ >= quarterly("2013 Q2","YQ")) & (checking<.);
gen		stocks		= secestx;					/* -2013q1 */; 
replace	stocks		= stockx if stocks==.;	 	/* 2013q2- */;
gen		studentdebt = studntx; 					/* 2013q2- */;
gen		retacc		= irax;						/* 2013q2- */;
gen		othassets	= othastx;					/* 2013q2- */;
gen		othdebt		= othlonx;					/* 2013q2- */;
gen		savbond		= usbndx;					/* 1996q1-2013q1 */;

* Don't know;
gen		pension		= fpripenx;					/* -2004q1,2006q1- */;
replace	pension		= fpripenm if pension==.;	/* 2004q1- */;



* Income variables;
gen		income			= cuincome;				/* -2007q1 */;
gen		income_post		= fincatxm;				/* 2004q1-2015q5 */;
gen		income_pre		= fincbtxm;				/* 2004q1-2013q1 */;
gen		earnings		= earnincx;				/* -2004q1 */;
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
gen		othrentinc		= inclossb;				/* -2004q1,2006q1- */;
replace	othrentinc		= inclosbm 	if othrentinc==.;	/* 2004q1-2013q1 */;
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

* Other;
gen		incrank			= inc_rnkm;				/* 2004q1- */;
gen		poverty			= pov_cym;				/* 2004q1-2014q1 */;

////////////////////////////////////////////////////////////////////////////////
* DEFINE NEW VARIABLES;

gen brliqpos = checking + saving + stocks;
gen brliqneg = ccdebt;
gen netbrliq = brliqpos - brliqneg;
gen brilliqpos = studentdebt + irax + othassets + savbond;


////////////////////////////////////////////////////////////////////////////////
* SAVE;
save ${basedir}/build/output/fmli_cleaned, replace;
