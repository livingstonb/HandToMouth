
// Code originally written by Justin Weidner

****EXTRACTS FROM THE FAMILY FILES THE VARIABLES OF INTEREST *****
cap mkdir $basedir/build/temp

cd $basedir/build/input
clear
set more off
set maxvar 20000
* cap log close
* log using $basedir/create1a_readfam.log,replace t

u fam1999er/fam1999er

rename ER13002 intid   //interview number 1999
rename ER13019 id68    //FAMILY NUMBER - id
rename ER16518 famwgt  //aweights

// CONSUMPTION MEASURES
rename ER13041 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER13065 rentrep  // missing = 99998|99999
rename ER13066 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER13071 rentfreerep // missing = 9998|9999
rename ER13072 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER13086 utilelecrep     // missing = 9998|9999
rename ER13087 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER13088 utilheatrep
rename ER13089 utilheattime
rename ER13090 utilwatrrep
rename ER13091 utilwatrtime
gen utiltelrep = .
gen utilteltime = .
rename ER13097 utilothrrep
rename ER13098 utilothrtime
// UTIL = elec+heat+watr+othr

rename ER13043 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER14285 fstmprep // num(6.0)
rename ER14286 fstmptime // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER14288 foodfstmprep // num(5.0)
rename ER14289 foodfstmptime
rename ER14295 foodregrep // num(5.0)
rename ER14296 foodregtime
// FOOD 

rename ER14291 fdelfstmprep // num(5.0)
rename ER14292 fdelfstmptime
rename ER14298 fdelregrep // num(5.0)
rename ER14299 fdelregtime
// FOOD DELIvERED

rename ER14293 foutfstmprep // num(5.0)
rename ER14294 foutfstmptime
rename ER14300 foutregrep //num(5.0)
rename ER14301 foutregtime 
// FOOD OUT

rename ER15780 hlthinsurancebi // num(6.0)
rename ER15781 hlthhospbi // num(6.0)
rename ER15787 hlthdoctorbi // num(7.0)
rename ER15793 hlthrxbi    // num(7.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER13191 autoinsurancerep // num(6.0)
rename ER13192 autoinsurancetime 
// AUTO INSURANCE

rename ER13195 carrepairmonth // num(5.0)
rename ER13196 gasolinemonth // num(5.0)
rename ER13197 parkingmonth // num(5.0)
rename ER13198 bustrainmonth // num(5.0)
rename ER13199 taximonth // num(5.0)
rename ER13200 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER13202 schoolexpyear // num(6.0)
rename ER13204 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER14232 childcarerep // num(6.0)
gen childcaretime = 6
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER16462   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER16463  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER16465 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER16452  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER16456  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER16454  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER16458  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9


rename ER16432   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER13004  state   // STATE
rename ER13009  fsize   // # IN FU
rename ER13008A  fchg   // family composition change since last wave
rename ER13010    age   // AGE OF HEAD (missing = 999)
rename ER13011    sex   // SEX OF HEAD
rename ER13012   agew   // AGE OF WIFE
rename ER13013   kids
rename ER13021  marit   // MARITAL STATUS
rename ER13205  empst   // WORKING NOW
rename ER13210   self   // SELF-EMPLOYED
rename ER13213 unionj   // Head's Job covered by a union contract
rename ER13214 unioni   // Head belongs to a labor union
rename ER14976 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER15449  disab   // HEAD DISABLED
rename ER15552 weight   // WEIGHT (missing = 999)
rename ER15890  newhd   // whether same head as in last wave 
rename ER15928   race   // RACE
rename ER15935    vet   // HEADS A VETERAN
rename ER16471  hours   // YRLY HEADS HRS
rename ER16514   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER16516   educ   // HEADS EDUCATION


gen            split = .  // has info in 01-11 (whether family a splitoff from 1968)



gen            oassinc = .          // asset income of OFUM (available 2005-2011)
rename ER14479 hrentincrep          // num(6.0), 8-9
rename ER14480 hrentinctime   
rename ER14494 hdividendincrep      // num(6.0), 8-9
rename ER14495 hdividendinctime 
rename ER14509 hinterestincrep      // num(6.0), 8-9
rename ER14510 hinterestinctime
rename ER14524 htrustfundrep        // num(6.0), 8-9
rename ER14525 htrustfundtime
rename ER14790 wdividendincrep      // num(6.0), 8-9
rename ER14791 wdividendinctime
rename ER14805 winterestincrep      // num(6.0), 8-9
rename ER14806 winterestinctime
rename ER14820 wtrustfundrep        // num(6.0), 8-9
rename ER14821 wtrustfundtime
rename ER16491 hassbus //annual
rename ER16512 wassbus //annual
rename ER16448 hassfarm //both labor and asset
rename ER16490 hlabbus
rename ER16511 wlabbus
//asset = sum (above)

drop ER*
gen year = 1999
compress
sort intid
save $basedir/build/temp/f99, replace

u fam2001er/fam2001er

rename ER17002 intid   //interview number 1999
rename ER17022 id68    //FAMILY NUMBER - id
rename ER20394 famwgt

// CONSUMPTION MEASURES
rename ER17044 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER17074 rentrep  // missing = 99998|99999
rename ER17075 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER17081 rentfreerep // missing = 9998|9999
rename ER17082 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER17097 utilelecrep     // missing = 9998|9999
rename ER17098 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER17099 utilheatrep
rename ER17100 utilheattime
rename ER17101 utilwatrrep
rename ER17102 utilwatrtime
gen utiltelrep = .
gen utilteltime = .
rename ER17108 utilothrrep
rename ER17109 utilothrtime
// UTIL = elec+heat+watr+othr

rename ER17048 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER18417 fstmprep // num(6.0)
rename ER18418 fstmptime // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER18421 foodfstmprep // num(5.0)
rename ER18422 foodfstmptime
rename ER18431 foodregrep // num(5.0)
rename ER18432 foodregtime
// FOOD 

rename ER18425 fdelfstmprep // num(5.0)
rename ER18426 fdelfstmptime
rename ER18435 fdelregrep // num(5.0)
rename ER18436 fdelregtime
// FOOD DELIvERED

rename ER18428 foutfstmprep // num(5.0)
rename ER18429 foutfstmptime
rename ER18438 foutregrep //num(5.0)
rename ER18439 foutregtime 
// FOOD OUT

rename ER19841 hlthinsurancebi // num(6.0)
rename ER19842 hlthhospbi // num(6.0)
rename ER19848 hlthdoctorbi // num(7.0)
rename ER19854 hlthrxbi    // num(7.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER17202 autoinsurancerep // num(6.0)
rename ER17203 autoinsurancetime 
// AUTO INSURANCE

rename ER17206 carrepairmonth // num(5.0)
rename ER17207 gasolinemonth // num(5.0)
rename ER17208 parkingmonth // num(5.0)
rename ER17209 bustrainmonth // num(5.0)
rename ER17210 taximonth // num(5.0)
rename ER17211 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER17213 schoolexpyear // num(6.0)
rename ER17215 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER18362 childcarerep // num(6.0)
gen childcaretime = 6
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER20456   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER20443  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER20447 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER20449  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER20453  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER20450  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER20454  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER20378   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER17004  state   // STATE
rename ER17012  fsize   // # IN FU
rename ER17007   fchg   // family composition change since last wave
rename ER17013    age   // AGE OF HEAD (missing = 999)
rename ER17014    sex   // SEX OF HEAD
rename ER17015   agew   // AGE OF WIFE
rename ER17016   kids
rename ER17024  marit   // MARITAL STATUS
rename ER17216  empst   // WORKING NOW
rename ER17221   self   // SELF-EMPLOYED
rename ER17224 unionj   // Head's Job covered by a union contract
rename ER17225 unioni   // Head belongs to a labor union
rename ER19172 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER19614  disab   // HEAD DISABLED
rename ER19717 weight   // WEIGHT (missing = 999)
rename ER19951  newhd   // whether same head as in last wave 
rename ER19989   race   // RACE
rename ER19996    vet   // HEADS A VETERAN
rename ER20399  hours   // YRLY HEADS HRS
rename ER20451   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER20457   educ   // HEADS EDUCATION


rename ER17006  split   // has info in 01-11 (whether family a splitoff from 1968)



gen            oassinc = . // asset income of OFUM (available 2005-2011)
rename ER18634 hrentincrep
rename ER18635 hrentinctime
rename ER18650 hdividendincrep
rename ER18651 hdividendinctime
rename ER18666 hinterestincrep
rename ER18667 hinterestinctime
rename ER18683 htrustfundrep
rename ER18684 htrustfundtime
rename ER18966 wdividendincrep
rename ER18967 wdividendinctime
rename ER18982 winterestincrep
rename ER18983 winterestinctime
rename ER18998 wtrustfundrep
rename ER18999 wtrustfundtime
rename ER20423 hassbus //annual
rename ER20445 wassbus //annual
rename ER20420 hassfarm
rename ER20422 hlabbus
rename ER20444 wlabbus
//asset = sum (above)


drop ER*
gen year = 2001
compress
sort intid
save $basedir/build/temp/f01, replace


u fam2003er/fam2003er

rename ER21002 intid   //interview number 1999
rename ER21009 id68    //FAMILY NUMBER - id
rename ER24179 famwgt

// CONSUMPTION MEASURES
rename ER21043 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER21072 rentrep  // missing = 99998|99999
rename ER21073 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER21079 rentfreerep // missing = 9998|9999
rename ER21080 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER21086 utilelecrep     // missing = 9998|9999
rename ER21087 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER21088 utilheatrep
rename ER21089 utilheattime
rename ER21090 utilwatrrep
rename ER21091 utilwatrtime
gen utiltelrep = .
gen utilteltime = .
rename ER21097 utilothrrep
rename ER21098 utilothrtime
// UTIL = elec+heat+watr+othr

rename ER21047 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER21682 fstmprep // num(6.0)
rename ER21683 fstmptime // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER21686 foodfstmprep // num(5.0)
rename ER21687 foodfstmptime
rename ER21696 foodregrep // num(5.0)
rename ER21697 foodregtime
// FOOD 

rename ER21690 fdelfstmprep // num(5.0)
rename ER21691 fdelfstmptime
rename ER21700 fdelregrep // num(5.0)
rename ER21701 fdelregtime
// FOOD DELIvERED

rename ER21693 foutfstmprep // num(5.0)
rename ER21694 foutfstmptime
rename ER21703 foutregrep //num(5.0)
rename ER21704 foutregtime 
// FOOD OUT

rename ER23278 hlthinsurancebi // num(6.0)
rename ER23279 hlthhospbi // num(6.0)
rename ER23285 hlthdoctorbi // num(7.0)
rename ER23291 hlthrxbi    // num(7.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER21838 autoinsurancerep // num(6.0)
rename ER21839 autoinsurancetime 
// AUTO INSURANCE

rename ER21842 carrepairmonth // num(5.0)
rename ER21843 gasolinemonth // num(5.0)
rename ER21844 parkingmonth // num(5.0)
rename ER21845 bustrainmonth // num(5.0)
rename ER21846 taximonth // num(5.0)
rename ER21847 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER21849 schoolexpyear // num(6.0)
rename ER21851 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER21628 childcarerep // num(6.0)
gen childcaretime = 6
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER24099   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER24116  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER24135 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER24100  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER24102  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER24101  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER24103  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER24145   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER21003  state   // STATE
rename ER21016  fsize   // # IN FU
rename ER21007   fchg   // family composition change since last wave
rename ER21017    age   // AGE OF HEAD (missing = 999)
rename ER21018    sex   // SEX OF HEAD
rename ER21019   agew   // AGE OF WIFE
rename ER21020   kids
rename ER21023  marit   // MARITAL STATUS
rename ER21123  empst   // WORKING NOW
rename ER21147   self   // SELF-EMPLOYED
rename ER21150 unionj   // Head's Job covered by a union contract
rename ER21151 unioni   // Head belongs to a labor union
rename ER22537 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER23014  disab   // HEAD DISABLED
rename ER23132 weight   // WEIGHT (missing = 999)
rename ER23388  newhd   // whether same head as in last wave 
rename ER23426   race   // RACE
rename ER23433    vet   // HEADS A VETERAN
rename ER24080  hours   // YRLY HEADS HRS
rename ER24137   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER24148   educ   // HEADS EDUCATION


rename ER21005  split    // has info in 01-11 (whether family a splitoff from 1968)



gen            oassinc = . // asset income of OFUM (available 2005-2011)
rename ER22003 hrentinc
rename ER22004 hrentinctime
rename ER22020 hdividendinc
rename ER22021 hdividendinctime
rename ER22037 hinterestinc
rename ER22038 hinterestinctime
rename ER22055 htrustfund
rename ER22056 htrustfundtime
rename ER22353 wdividendinc
rename ER22354 wdividendinctime
rename ER22370 winterestinc
rename ER22371 winterestinctime
rename ER22336 wrentincrep
rename ER22337 wrentinctime
rename ER22387 wtrustfund
rename ER22388 wtrustfundtime

rename ER24110 hassbus
rename ER24112 wassbus
rename ER24105 hassfarm
rename ER24109 hlabbus
rename ER24111 wlabbus
//asset = sum (above)


drop ER*
gen year = 2003
compress
sort intid
save $basedir/build/temp/f03, replace

u fam2005er/fam2005er

rename ER25002 intid   //interview number 1999
rename ER25009 id68    //FAMILY NUMBER - id
rename ER28078 famwgt

// CONSUMPTION MEASURES
rename ER25029 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER25063 rentrep  // missing = 99998|99999
rename ER25064 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER25070 rentfreerep // missing = 9998|9999
rename ER25071 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER25082 utilelecrep     // missing = 9998|9999
rename ER25083 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER25080 utilheatrep
rename ER25081 utilheattime
rename ER25084 utilwatrrep
rename ER25085 utilwatrtime
rename ER25086 utiltelrep
rename ER25087 utilteltime
rename ER25090 utilothrrep
rename ER25091 utilothrtime
// UTIL = elec+heat+watr+tel+othr

rename ER25038 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER25684 fstmprep // num(6.0)
rename ER25685 fstmptime // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER25688 foodfstmprep // num(5.0)
rename ER25689 foodfstmptime
rename ER25698 foodregrep // num(5.0)
rename ER25699 foodregtime
// FOOD 

rename ER25692 fdelfstmprep // num(5.0)
rename ER25693 fdelfstmptime
rename ER25702 fdelregrep // num(5.0)
rename ER25703 fdelregtime
// FOOD DELIvERED

rename ER25695 foutfstmprep // num(5.0)
rename ER25696 foutfstmptime
rename ER25705 foutregrep //num(5.0)
rename ER25706 foutregtime 
// FOOD OUT

rename ER27238 hlthinsurancebi // num(6.0)
rename ER27239 hlthhospbi // num(6.0)
rename ER27245 hlthdoctorbi // num(6.0)
rename ER27251 hlthrxbi    // num(6.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER25794 autoinsurancerep // num(6.0)
rename ER25795 autoinsurancetime 
// AUTO INSURANCE

rename ER25798 carrepairmonth // num(5.0)
rename ER25799 gasolinemonth // num(5.0)
rename ER25800 parkingmonth // num(5.0)
rename ER25801 bustrainmonth // num(5.0)
rename ER25802 taximonth // num(5.0)
rename ER25803 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER25804 schoolexpyear // num(6.0)
rename ER25805 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER25628 childcarerep // num(6.0)
gen childcaretime = 6
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER28037   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER27931  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER27943 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER27953  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER28009  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER28002  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER28030  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER28044   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER25003  state   // STATE
rename ER25016  fsize   // # IN FU
rename ER25007   fchg   // family composition change since last wave
rename ER25017    age   // AGE OF HEAD (missing = 999)
rename ER25018    sex   // SEX OF HEAD
rename ER25019   agew   // AGE OF WIFE
rename ER25020   kids
rename ER25023  marit   // MARITAL STATUS
rename ER25104  empst   // WORKING NOW
rename ER25129   self   // SELF-EMPLOYED
rename ER25138 unionj   // Head's Job covered by a union contract
rename ER25139 unioni   // Head belongs to a labor union
rename ER26518 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER26995  disab   // HEAD DISABLED
rename ER27109 weight   // WEIGHT (missing = 999)
rename ER27352  newhd   // whether same head as in last wave 
rename ER27393   race   // RACE
rename ER27400    vet   // HEADS A VETERAN
rename ER27886  hours   // YRLY HEADS HRS
rename ER28003   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER28047   educ   // HEADS EDUCATION


rename ER25005  split    // has info in 01-11 (whether family a splitoff from 1968)



rename ER27932 hrentinc
rename ER27934 hdividendinc
rename ER27936 hinterestinc
rename ER27938 htrustfund
rename ER27947 wdividendinc
rename ER27949 winterestinc
rename ER27945 wrentinc
rename ER27951 wtrustfund //no missing

rename ER28007 oassinc

rename ER27911 hassbus
rename ER27941 wassbus
rename ER27908 hassfarm
rename ER27910 hlabbus
rename ER27940 wlabbus //no missing
//asset = sum (above)


drop ER*
gen year = 2005
compress
sort intid
save $basedir/build/temp/f05, replace 


u fam2007er/fam2007er

rename ER36002 intid   //interview number 1999
rename ER36009 id68    //FAMILY NUMBER - id
rename ER41069 famwgt

// CONSUMPTION MEASURES
rename ER36029 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER36065 rentrep  // missing = 99998|99999
rename ER36066 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER36072 rentfreerep // missing = 9998|9999
rename ER36073 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER36085 utilelecrep     // missing = 9998|9999
rename ER36086 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER36083 utilheatrep
rename ER36084 utilheattime
rename ER36087 utilcombrep
rename ER36088 utilcombtime
rename ER36089 utilwatrrep
rename ER36090 utilwatrtime
rename ER36091 utiltelrep
rename ER36092 utilteltime
rename ER36093 utilothrrep
rename ER36094 utilothrtime
// UTIL = elec+heat+comb+watr+tel+othr

rename ER36038 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER36702 fstmprep // num(6.0)
rename ER36703 fstmptime // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER36706 foodfstmprep // num(5.0)
rename ER36707 foodfstmptime
rename ER36716 foodregrep // num(5.0)
rename ER36717 foodregtime
// FOOD 

rename ER36710 fdelfstmprep // num(5.0)
rename ER36711 fdelfstmptime
rename ER36720 fdelregrep // num(5.0)
rename ER36721 fdelregtime
// FOOD DELIvERED

rename ER36713 foutfstmprep // num(5.0)
rename ER36714 foutfstmptime
rename ER36723 foutregrep //num(5.0)
rename ER36724 foutregtime 
// FOOD OUT

rename ER40410 hlthinsurancebi // num(6.0)
rename ER40414 hlthhospbi // num(6.0)
rename ER40420 hlthdoctorbi // num(6.0)
rename ER40426 hlthrxbi    // num(6.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER36812 autoinsurancerep // num(6.0)
rename ER36813 autoinsurancetime 
// AUTO INSURANCE

rename ER36816 carrepairmonth // num(5.0)
rename ER36817 gasolinemonth // num(5.0)
rename ER36818 parkingmonth // num(5.0)
rename ER36819 bustrainmonth // num(5.0)
rename ER36820 taximonth // num(5.0)
rename ER36821 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER36823 schoolexpyear // num(6.0)
rename ER36825 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER36633 childcarerep // num(6.0)
rename ER36634 childcaretime
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER41027   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER40921  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER40933 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER40943  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER40999  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER40992  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER41020  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER41034   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER36003  state   // STATE
rename ER36016  fsize   // # IN FU
rename ER36007   fchg   // family composition change since last wave
rename ER36017    age   // AGE OF HEAD (missing = 999)
rename ER36018    sex   // SEX OF HEAD
rename ER36019   agew   // AGE OF WIFE
rename ER36020   kids
rename ER36023  marit   // MARITAL STATUS
rename ER36109  empst   // WORKING NOW
rename ER36134   self   // SELF-EMPLOYED
rename ER36143 unionj   // Head's Job covered by a union contract
rename ER36144 unioni   // Head belongs to a labor union
rename ER37536 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER38206  disab   // HEAD DISABLED
rename ER38320 weight   // WEIGHT (missing = 999)
rename ER40527  newhd   // whether same head as in last wave 
rename ER40565   race   // RACE
rename ER40572    vet   // HEADS A VETERAN
rename ER40876  hours   // YRLY HEADS HRS
rename ER40993   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER41037   educ   // HEADS EDUCATION


rename ER36005  split    // has info in 01-11 (whether family a splitoff from 1968)



rename ER40922 hrentinc
rename ER40924 hdividendinc
rename ER40926 hinterestinc
rename ER40928 htrustfund
rename ER40937 wdividendinc
rename ER40939 winterestinc
rename ER40935 wrentinc
rename ER40941 wtrustfund
rename ER40901 hassbus
rename ER40931 wassbus
rename ER40898 hassfarm
rename ER40900 hlabbus
rename ER40930 wlabbus
rename ER40997 oassinc


//asset = sum (above)


drop ER*
gen year = 2007
compress
sort intid
save $basedir/build/temp/f07, replace 


u fam2009er/fam2009er

rename ER42002 intid   //interview number 1999
rename ER42009 id68    //FAMILY NUMBER - id
rename ER47012 famwgt

// CONSUMPTION MEASURES
rename ER42030 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER42080 rentrep  // missing = 99998|99999
rename ER42081 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER42087 rentfreerep // missing = 9998|9999
rename ER42088 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER42114 utilelecrep     // missing = 9998|9999
rename ER42115 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER42112 utilheatrep
rename ER42113 utilheattime
rename ER42116 utilcombrep
rename ER42117 utilcombtime
rename ER42118 utilwatrrep
rename ER42119 utilwatrtime
rename ER42120 utiltelrep
rename ER42121 utilteltime
rename ER42124 utilothrrep
rename ER42125 utilothrtime
// UTIL = elec+heat+comb+watr+tel+othr

rename ER42039 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER42709 fstmprep // num(6.0)
gen            fstmptime = 5 // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER42712 foodfstmprep // num(5.0)
rename ER42713 foodfstmptime
rename ER42722 foodregrep // num(5.0)
rename ER42723 foodregtime
// FOOD 

rename ER42716 fdelfstmprep // num(5.0)
rename ER42717 fdelfstmptime
rename ER42726 fdelregrep // num(5.0)
rename ER42727 fdelregtime
// FOOD DELIvERED

rename ER42719 foutfstmprep // num(5.0)
rename ER42720 foutfstmptime
rename ER42729 foutregrep //num(5.0)
rename ER42730 foutregtime 
// FOOD OUT

rename ER46383 hlthinsurancebi // num(6.0)
rename ER46387 hlthhospbi // num(6.0)
rename ER46393 hlthdoctorbi // num(6.0)
rename ER46399 hlthrxbi    // num(6.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER42803 autoinsurancerep // num(6.0)
rename ER42804 autoinsurancetime 
// AUTO INSURANCE

rename ER42807 carrepairmonth // num(5.0)
rename ER42808 gasolinemonth // num(5.0)
rename ER42809 parkingmonth // num(5.0)
rename ER42810 bustrainmonth // num(5.0)
rename ER42819 taximonth // num(5.0)
rename ER42812 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER42814 schoolexpyear // num(6.0)
rename ER42816 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER42652 childcarerep // num(6.0)
rename ER42653 childcaretime
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER46935   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER46829  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER46841 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER46851  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER46907  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER46900  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER46928  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER46976   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER42003  state   // STATE
rename ER42016  fsize   // # IN FU
rename ER42007   fchg   // family composition change since last wave
rename ER42017    age   // AGE OF HEAD (missing = 999)
rename ER42018    sex   // SEX OF HEAD
rename ER42019   agew   // AGE OF WIFE
rename ER42020   kids
rename ER42023  marit   // MARITAL STATUS
rename ER42140  empst   // WORKING NOW
rename ER42169   self   // SELF-EMPLOYED
rename ER42178 unionj   // Head's Job covered by a union contract
rename ER42179 unioni   // Head belongs to a labor union
rename ER43527 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER44179  disab   // HEAD DISABLED
rename ER44293 weight   // WEIGHT (missing = 999)
rename ER46504  newhd   // whether same head as in last wave 
rename ER46543   race   // RACE
rename ER46550    vet   // HEADS A VETERAN
rename ER46767  hours   // YRLY HEADS HRS
rename ER46901   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER46981   educ   // HEADS EDUCATION


rename ER42005  split    // has info in 01-11 (whether family a splitoff from 1968)



rename ER46830 hrentinc
rename ER46832 hdividendinc
rename ER46834 hinterestinc
rename ER46836 htrustfund
rename ER46845 wdividendinc
rename ER46847 winterestinc
rename ER46843 wrentinc
rename ER46849 wtrustfund

rename ER46809 hassbus
rename ER46839 wassbus
rename ER46806 hassfarm
rename ER46808 hlabbus
rename ER46838 wlabbus
rename ER46905 oassinc
//asset = sum (above)

drop ER*
gen year = 2009
compress
sort intid
save $basedir/build/temp/f09, replace


u fam2011er/fam2011er

rename ER47302 intid   //interview number 1999
rename ER47309 id68    //FAMILY NUMBER - id
rename ER52436 famwgt

// CONSUMPTION MEASURES
rename ER47330 house   //HOUSE VALUE (missing = 9999998 | 9999999)

rename ER47387 rentrep  // missing = 99998|99999
rename ER47388 renttime // 3= week, 4 = two week, 5 = month, 6 = year
rename ER47395 rentfreerep // missing = 9998|9999
rename ER47396 rentfreetime // 3= week, 4 = two week, 5 = month, 6 = year
// RENT = rent + rentfree + 0.06*housing value

rename ER47417 utilelecrep     // missing = 9998|9999
rename ER47418 utilelectime // 5 = monthly, 6 = yearly, oth = missing/
rename ER47415 utilheatrep
rename ER47416 utilheattime
rename ER47419 utilcombrep
rename ER47420 utilcombtime
rename ER47421 utilwatrrep
rename ER47422 utilwatrtime
rename ER47423 utiltelrep
rename ER47424 utilteltime
rename ER47425 utilothrrep
rename ER47426 utilothrtime
// UTIL = elec+heat+comb+watr+tel+othr


rename ER47344 homeinsur // num(4.0)
// HOME INSURANCE (annual)

rename ER48025 fstmprep // num(6.0)
gen fstmptime = 5 // 3= week, 4 = two week, 5 = month, 6 = year
// FOOD STAMPS RECEIVED

rename ER48028 foodfstmprep // num(5.0)
rename ER48029 foodfstmptime
rename ER48038 foodregrep // num(5.0)
rename ER48039 foodregtime
// FOOD 

rename ER48032 fdelfstmprep // num(5.0)
rename ER48033 fdelfstmptime
rename ER48042 fdelregrep // num(5.0)
rename ER48043 fdelregtime
// FOOD DELIvERED

rename ER48035 foutfstmprep // num(5.0)
rename ER48036 foutfstmptime
rename ER48045 foutregrep //num(5.0)
rename ER48046 foutregtime 
// FOOD OUT

rename ER51744 hlthinsurancebi // num(6.0)
rename ER51748 hlthhospbi // num(6.0)
rename ER51754 hlthdoctorbi // num(6.0)
rename ER51760 hlthrxbi    // num(6.0)
// HEALTH CARE (TWO YEAR EXPENSES)

rename ER48125 autoinsurancerep // num(6.0)
rename ER48126 autoinsurancetime 
// AUTO INSURANCE

rename ER48129 carrepairmonth // num(5.0)
rename ER48130 gasolinemonth // num(5.0)
rename ER48131 parkingmonth // num(5.0)
rename ER48132 bustrainmonth // num(5.0)
rename ER48133 taximonth // num(5.0)
rename ER48134 transothmonth // num(5.0)
// TRANSPORTATION (MONTHLY EXPENSES)

rename ER48136 schoolexpyear // num(6.0)
rename ER48138 schoolothyear // num(6.0)
// EDUCATION (ANNUAL EXPENSES)

rename ER47970 childcarerep // num(6.0)
rename ER47971 childcaretime 
// CHILD CARE

// END OF NON-DURABLE CONSUMPTION

// INCOME

rename ER52343   y      // num(7.0) : TOTAL FAMILY INCOME
rename ER52237  ly      // num(7.0) : LABOR INCOME-HEAD
rename ER52249 wly      // num(7.0) : LABOR INCOME-WIFE
rename ER52259  tyhw    // num(7.0) : HD+WF TAXABLE INCOME
rename ER52315  tyoth   // num(7.0) : OFUM TAXABLE INCOME
rename ER52308  trhw    // num(7.0) : HD+WF TRANSFER INCOME
rename ER52336  troth   // num(7.0) : OFUM TRANSFER INCOME
//ftax = .  // IMPUTE FAM INC TAX FROM y, kids USING stata taxsim9

rename ER52400   smsa   // Local place (size of largest city in the sampling area)
                          // No longer in public access data                        
rename ER47303  state   // STATE
rename ER47316  fsize   // # IN FU
rename ER47307   fchg   // family composition change since last wave
rename ER47317    age   // AGE OF HEAD (missing = 999)
rename ER47318    sex   // SEX OF HEAD
rename ER47319   agew   // AGE OF WIFE
rename ER47320   kids
rename ER47323  marit   // MARITAL STATUS
rename ER47448  empst   // WORKING NOW
rename ER47482   self   // SELF-EMPLOYED
rename ER47491 unionj   // Head's Job covered by a union contract
rename ER47492 unioni   // Head belongs to a labor union
rename ER48852 outkid   // SUPPORT ANYONE NOT LIVING WITH YOU
rename ER49498  disab   // HEAD DISABLED
rename ER49631 weight   // WEIGHT (missing = 999)
rename ER51865  newhd   // whether same head as in last wave 
rename ER51904   race   // RACE
rename ER51911    vet   // HEADS A VETERAN
rename ER52175  hours   // YRLY HEADS HRS
rename ER52309   avhy   // HEAD HOURLY EARN (missing = 99.99)
rename ER52405   educ   // HEADS EDUCATION


rename ER47305  split    // has info in 01-11 (whether family a splitoff from 1968)



rename ER52238 hrentinc
rename ER52240 hdividendinc
rename ER52242 hinterestinc
rename ER52244 htrustfund
rename ER52253 wdividendinc
rename ER52255 winterestinc
rename ER52251 wrentinc
rename ER52257 wtrustfund
rename ER52217 hassbus
rename ER52247 wassbus
rename ER52214 hassfarm
rename ER52216 hlabbus
rename ER52246 wlabbus
rename ER52313 oassinc
//asset = sum (above)


drop ER*
gen year = 2011
compress
sort intid
save $basedir/build/temp/f11, replace

u fam2013er/fam2013er

rename ER53020 kids
rename ER53023 marit

rename ER53002 intid   //interview number 1999
rename ER53009 id68    //FAMILY NUMBER - id
rename ER58257 famwgt

rename ER58039 hrentinc
rename ER58041 hdividendinc
rename ER58043 hdinterestinc
rename ER58045 hdtrustfund
rename ER58054 wdividendinc
rename ER58056 winterestinc
rename ER58052 wrentinc
rename ER58058 wtrustfund
rename ER58018 hassbus
rename ER58048 wassbus
rename ER58015 hassfarm
rename ER58017 hlabbus
rename ER58047 wlabbus
rename ER58122 oassinc

drop ER*
gen year = 2013
compress
sort intid
save $basedir/build/temp/f13, replace

////////////////////////////////////////////////////////////////////////////////

u fam2015er/fam2015er

rename ER60021 kids
rename ER60024 marit

rename ER60002 intid   //interview number 1999
rename ER60009 id68    //FAMILY NUMBER - id
rename ER65492 famwgt

rename ER65217 hrentinc
rename ER65219 hdividendinc
rename ER65221 hdinterestinc
rename ER65223 hdtrustfund
rename ER65247 wdividendinc
rename ER65249 winterestinc
rename ER65245 wrentinc
rename ER65251 wtrustfund
rename ER65198 hassbus
rename ER65226 wassbus
rename ER65195 hassfarm
rename ER65197 hlabbus
rename ER65225 wlabbus
rename ER65319 oassinc

drop ER*
gen year = 2015
compress
sort intid
save $basedir/build/temp/f15, replace

cd $basedir/build/temp
use f99, clear
append using f01
append using f03
append using f05
append using f07
append using f09
append using f11
append using f13
append using f15
save fam, replace


erase f99.dta
erase f01.dta
erase f03.dta
erase f05.dta
erase f07.dta
erase f09.dta
erase f11.dta
erase f13.dta
erase f15.dta


* log close





