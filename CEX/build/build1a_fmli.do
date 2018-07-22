#delimit;
clear*;
set more 1;
cap mkdir ${basedir}/build/temp;

////////////////////////////////////////////////////////////////////////////////
* APPEND QUARTERS;

local firstyear 11;
local lastyear	16;

* Create yearly datasets;
forvalues yy = `firstyear'/`lastyear' {;
	forvalues q = 1/4 {;
		di "`yy'q`q'";
		if `q'==1 {;
				cd ${basedir}/build/input;
				use intrvw`yy'/intrvw`yy'/fmli`yy'`q'x, clear;
				gen q = `q';
		};
		else {;
			append using intrvw`yy'/intrvw`yy'/fmli`yy'`q';
			replace q = `q' if q==.;
		};
	};
	if (`yy'==15) | (`yy'==16) {;
		destring newid, replace;
	};
	gen year = `yy';
	save ${basedir}/build/temp/fmli`yy', replace;
};

* Append years;
forvalues yy = `firstyear'/`lastyear' {;
	if `yy'==`firstyear' {;
		use ${basedir}/build/temp/fmli`yy', clear;
	};
	else {;
		append using ${basedir}/build/temp/fmli`yy';
	};
};

////////////////////////////////////////////////////////////////////////////////
* CLEAN;

* Create datetime variable;


* CU characteristics;
gen		id 			= newid;
gen		age			= age_ref;
gen		agesp		= age2;
gen		housetenure	= cutenure;
gen		educ		= educ_ref;
gen		educsp		= educa2;
gen		educhighest = high_edu;
gen		hisp1		= horref1; 		/* 2009q1- */;
gen		hisp2		= horref2;		/* 2009q2- */;
gen		famsize		= fam_size;	
gen		intmonth	= qintrvmo;		/* - */;
gen		intyear		= qintrvyr;		/* - */;
gen		race1		= ref_race;		/* - */;
gen		sex			= sex_ref;		/* - */;
* race2 	= race2; 	/* - */;
* sex2		= sex2;		/* - */;
* region 	= region 	/* -*/;


* Wealth variables;
gen		ccdebt		= creditx;					/* 2013q2- */;
gen 	checking	= ckbkactx; 				/* 		 -2013q1 */;
replace checking 	= liquidx if year >>>>>>>>; /* 2013q2- */;
gen		saving		= savacctx; 				/* 		 -2013q1 */;
gen		stocks		= secestx;					/* 		 -2013q1 */; 
replace	stocks		= stockx if year >>>>>>>>; 	/* 2013q2- */;
gen		studentdebt = studntx; 					/* 2013q2- */;
gen		retacc		= irax;						/* 2013q2- */;
gen		othassets	= othastx;					/* 2013q2- */;
gen		othdebt		= othlonx;					/* 2013q2- */;
gen		pension		= fripenx;					/* 		 -2004q1,2006q1- */;
replace	pension		= fripenm if year >>>>>>>>;	/* 2004q1- */;

STDNTYRX


* Income variables;
gen		income			= cuincome;				/* 		 -2007q1 */;
gen		income_post		= fincatxm;				/* 2004q1-2015q5 */;
gen		income_pre		= fincbtxm;				/* 2004q1-2013q1 */;
gen		earnings		= earnincx;				/* 		 -2004q1 */;
gen		wages			= fsalaryx;				/* 		 -2004q1,2006q1- */;
replace	wages			= fsalarym if year >>>>>>>>;		/* 2004q1- */;
gen		farm			= ffrminx				/* 		 -2004q1,2006q1-2013q1 */
replace	farm			= ffrmincm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen		bus				= fnonfrmx				/* 		 -2004q1,2006q1- */;
replace	bus				= fnonfrmm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen		selfearn		= fsmpfrxm;				/* 2013q2- */;
gen		rentinc			= inclossa				/* 		 -2004q1,2006q1- */;
replace	rentinc			= inclosam if year >>>>>>>>;		/* 2004q1-2013q1 */;
replace	rentinc			= netrentm if year >>>>>>>>;		/* 2013q2- */;
gen		othrentinc		= inclossb;				/* 		 -2004q1,2006q1- */;
replace	othrentinc		= inclosbm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen		savint			= intearnx;				/* 		 -2004q1,2006q1- */;
replace	savint			= intearnm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen 	int_and_div		= intrdvxm;				/*	2013q1- */;
gen		lumpsumtrust	= lumpsumx; 			/* 		 -2013q1 */;
gen		dividtrust		= finincxm;				/* 2004q1-2013q1 */;
gen		royalttrust		= royestxm;				/* 2013q1- */;
gen		alimony			= aliothxm; 			/* 2004q1-2013q1 */;
gen		childsupp		= chdlmpx;				/* 		 -2013q1 */;
gen		othchildsupp	= chdothxm;				/* 		 -2004q1,2006q1-2013q1 */;
gen		workcomp		= compensm;				/* 2004q1-2013q1 */;
gen		foodstamps		= foodsmpx;				/* 2001q2-2004q1,2006q1-2013q1 */;
replace	foodstamps		= foodsmpm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen 	socsec			= frretirx;				/* 		 -2004q1,2006q1- */;
replace	socsec			= frretirm if year >>>>>>>>;		/* 2004q1- */;
gen		ssi				= fssix;				/* 		 -2004q1,2006q1- */;
replace	ssi				= fssixm if year >>>>>>>>;		/* 2004q1- */;
gen		othinc			= othregxm;				/* 2013q2- */;
gen		othinc2			= othrincx;				/* 		 -2004q1,2006q1- */;
replace	othinc2			= othrincm if year >>>>>>>>;		/* 2004q1- */;
gen		pensioninc		= pensionx;				/* 		 -2004q1,2006q1- */;
replace	pensioninc		= pensionm if year >>>>>>>>;		/* 2004q1-2013q1 */;
gen		retsurv			= retsurvm;				/* 2013q2- */;
gen		sellhousehold	= saleincx;				/* 		 - 2013q1 */;

* Tax variables
gen		fedtaxdeducted	= famtfedx;				/* 		 -2004q1,2006q1-2015q1 */;
replace	fedtaxdeducted	= famtfedm if year >>>>>>>>;		/* 2004q1-2015q1 */;
gen		taxrefund		= fedr_ndx				/* 		 -2015q1 */;
gen		proptax			= proptxcq*4;			/* - */;	
gen		saltdeducted	= fsltaxx;				/* 		 -2004q1,2006q1-2015q1 */;
replace	saltdeducted	= fsltaxxm if year >>>>>>>>;		/* 2004q1-2015q1 */;

* Other;
gen		incrank			= inc_rnkm;		/* 2004q1- */;
gen		poverty			= pov_cym;		/* 2004q1-2014q1 */;


////////////////////////////////////////////////////////////////////////////////
* SAVE;
save ${basedir}/build/temp/fmli_allyears, replace;
