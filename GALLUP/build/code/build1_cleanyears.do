#delimit;

////////////////////////////////////////////////////////////////////////////////
clear*;
set more 1;
cap mkdir $basedir/build/temp;

////////////////////////////////////////////////////////////////////////////////

local commonvars region sex married workcat hispanic income wgt
		age year month nomoneyfoodpast12 state educ race children;
		
forvalues yr=2008(1)2017 {;
	cd $basedir/build/input;
	use US_DAILY_`yr'_DATA;
	
	rename CENREG 			region;
	rename SC7				sex;
	rename WP1223			married;
	rename WP1225			workcat;
	rename D5				hispanic;
	rename INCOME_SUMMARY	income;
	rename PE_WEIGHT 		wgt;
	rename WP1220			age;
	rename YEAR				year;
	rename MONTH			month;
	rename WP40				nomoneyfoodpast12;
	rename ZIPSTATE			state;
	rename EDUCATION 		educ;
	rename RACE				race;
	rename H17				children;
	
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
	
	* Variable Selection
	local `yearvars';
	keep `commonvars' `yearvars';
	
	cd $basedir/build/temp;
	save US_DAILY_`yr'_DATA_cleaned, replace;
	clear;
};

