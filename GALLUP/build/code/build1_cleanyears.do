#delimit;

/* This do-file selects which variables to keep from each of the year datasets,
then resaves the datasets in build/temp */;

////////////////////////////////////////////////////////////////////////////////
clear*;
set more 1;
cap mkdir $basedir/build/temp;

////////////////////////////////////////////////////////////////////////////////
* SELECT WHICH VARIABLES TO KEEP;
* Variables shared among all years;
local commonvars region sex married workcat hispanic income dailywgt MSAwgt
		age year month buyfood state educ race children
		INT_DATE MOTHERLODE_ID;
		
forvalues yr=2008(1)2017 {;
	cd $basedir/build/input;
	use US_DAILY_`yr'_DATA;
	
	rename CENREG 			region;
	rename SC7				sex;
	rename WP1223			married;
	rename WP1225			workcat;
	rename D5				hispanic;
	rename INCOME_SUMMARY	income;
	rename PE_WEIGHT 		dailywgt;
	rename PE_MSAWTS		MSAwgt;
	rename WP1220			age;
	rename YEAR				year;
	rename MONTH			month;
	rename WP40				buyfood;
	rename ZIPSTATE			state;
	rename EDUCATION 		educ;
	rename RACE				race;
	rename H17				children;
	
	* Variables unique to this year;
	local yearvars ;
	if `yr'>=2009 {;
		rename M92			majorpurchase;
		rename M93			cuttingback;
		rename M96			morethanenoughmoney;
		rename M97			affordneeds;
		local yearvars `yearvars' majorpurchase cuttingback morethanenoughmoney 
			affordneeds;
	};
	if `yr'>=2013 {;
		rename HWB5 		moneyforeverything;
		local yearvars `yearvars' moneyforeverything;
	};
	
	if `yr'<=2013 {;
		rename WP43			buyshelter;
		local yearvars `yearvars' buyshelter;
	};
	
	if `yr'<=2016 {;
		rename M1			buymedicine;
		local yearvars `yearvars' buymedicine;
	};
	
	keep `commonvars' `yearvars';
	
	cd $basedir/build/temp;
	save US_DAILY_`yr'_DATA_cleaned, replace;
	clear;
};

