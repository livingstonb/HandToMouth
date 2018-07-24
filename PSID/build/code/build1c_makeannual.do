cd $basedir
clear
set more off
* cap log close
* log using $basedir/create1c_makeannual, replace t

// Code originally written by Justin Weidner


/* Converts data to yearly */
cd $basedir/build/temp
u fam1a, clear

foreach var of varlist *time {
	gen temp = 0
	replace temp = 52 if `var'==3
	replace temp = 26 if `var'==4
	replace temp = 12 if `var'==5
	replace temp = 1  if `var'==6
	replace `var' = temp
	drop temp
}

foreach var of varlist *rep {
	replace `var' = 0 if `var' ==.
}

foreach var of varlist rent* house util* auto* fstmp* food* fdel* fout* ///
					   childcare* hrent* hdiv* hint* htrust* wrent* wdiv* ///
					   wint* wtrust* hlth* *month *year homeinsur hass* wass* oass* {
					   		replace `var' = 0 if `var' ==.
					   }

gen rent = rentrep * renttime + rentfreerep * rentfreetime + 0.06*house
gen utility = utilelecrep * utilelectime + utilheatrep * utilheattime + ///
	   	      utilwatrrep * utilwatrtime + utilcombrep * utilcombtime + ///
		      utiltelrep * utilteltime + utilothrrep * utilothrtime
gen autoinsurance = autoinsurancerep * autoinsurancetime
gen fstmp = fstmprep*fstmptime
gen food = foodfstmprep*foodfstmptime + foodregrep* foodregtime
gen fdel = fdelfstmprep*fdelfstmptime + fdelregrep* fdelregtime
gen fout = foutfstmprep*foutfstmptime + foutregrep* foutregtime
gen childcare = childcarerep*childcaretime
if year == 1999 | year == 2001 | year == 2003 {
	replace hrentinc = hrentincrep * hrentinctime
	replace hdividendinc = hdividendincrep * hdividendinctime
	replace hinterestinc = hinterestincrep * hinterestinctime
	replace htrustfund = htrustfundrep * htrustfundtime
	replace wrentinc = wrentincrep * wrentinctime
	replace wdividendinc = wdividendincrep * wdividendinctime
	replace winterestinc = winterestincrep * winterestinctime
	replace wtrustfund = wtrustfundrep * wtrustfundtime	
}
gen hlthservices = (hlthhospbi + hlthdoctorbi + hlthrxbi)*0.5
gen hlthinsurance = hlthinsurancebi*0.5
gen gasoline = gasolinemonth*12
gen transportation = autoinsurance + (carrepairmonth + parkingmonth + ///
	    bustrainmonth + taximonth + transothmonth)*12
gen educexpense = schoolexpyear + schoolothyear
//NON-DURABLE CONSUMPTION
gen ndur = food+fdel+fout+fstmp+gasoline+hlthinsurance+hlthservices+utility+ ///
           transportation+educexpense+childcare+homeinsur+rent
//ASSET INCOME
gen asset = hrentinc+hdividendinc+hinterestinc+htrustfund+hassbus+hassfarm+ ///
		    wrentinc+wdividendinc+winterestinc+wtrustfund+wassbus+oassinc

cd $basedir/build/temp
save fam1b, replace
