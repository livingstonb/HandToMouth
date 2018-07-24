cd $basedir/build/
// Code originally written by Justin Weidner


/* Top-codes the family dataset */

clear 
set more off
set maxvar 20000
* cap log close
* log using $basedir/create1b_topcoding,replace t

cd $basedir/build/temp
u fam, clear

*TOP-CODING - 998 - 999 VARIABLES

gen trunc = 0

foreach var of varlist age agew weight {
	replace `var' = . if `var' == 998 | `var' == 999
	replace trunc = 1 if `var' == 997
}

foreach var of varlist utilothrrep  {
	replace `var' = 0 if `var' == 998 | `var' == 999
	replace trunc = 1 if `var' == 997
}


*TOP-CODING - 9,998 - 9,999 VARIABLES

foreach var of varlist rentfreerep utilelecrep utilheatrep  ///
 	 utilwatrrep utiltelrep utilcombrep homeinsur {
 	replace `var' = 0 if `var' == 9998 | `var' == 9999	
	replace trunc = 1 if `var' == 9997	
 	} 

foreach var of varlist  avhy {
	replace `var' = 0 if `var' == 9998 | `var' == 9999
	replace trunc = 1 if `var' == 9997		
} 

*TOP-CODING - 99,998 - 99,999 VARIABLES

foreach var of varlist rentrep carrepairmonth gasolinemonth ///
	 parkingmonth bustrainmonth taximonth transothmonth ///
	 foodfstmprep fdelfstmprep foutfstmprep foodregrep  ///
	 fdelregrep foutregrep fstmprep {
		replace `var' = 0 if `var' == 99998 | `var' == 99999
		replace trunc = 1 if `var' == 99997
	}

*TOP-CODING - 999,998 - 999,999 VARIABLES

foreach var of varlist autoinsurancerep schoolexpyear schoolothyear ///
	childcarerep fstmprep hrentincrep hdividendincrep hinterestincrep /// 
	htrustfundrep wdividendincrep winterestincrep wtrustfundrep /// 
	wrentincrep hlthinsurancebi hlthhospbi hrentinc hdividendinc /// 
	hinterestinc wdividendinc winterestinc wtrustfund  {
		replace `var' = 0 if `var' == 999998 | `var' == 999999 | `var' == -99999
		replace trunc = 1 if `var' == 999997 | `var' == -99998
	}


*TOP-CODING - 9,999,998 - 9,999,999 VARIABLES

foreach var of varlist house hassbus wassbus {
	replace `var' = 0 if `var' == 9999998 | `var' == 9999999 | `var' == -999999
	replace trunc = 1 if `var' == 9999997 | `var' == -999998
}

foreach var of varlist hlthdoctorbi hlthrxbi {
	replace `var' = 0 if `var' == 9999998 | `var' == 9999999 | `var' == 999998 | `var' == 999999
	replace trunc = 1 if `var' == 9999997 | `var' == -999998 | `var' == 999997 | `var' == -99998
	}

cd $basedir/build/temp
save fam1a, replace 


