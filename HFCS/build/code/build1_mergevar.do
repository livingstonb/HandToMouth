
cap mkdir ${basedir}/build/temp

local waves HFCS1_3 HFCS2_1
local wavenum = 1
foreach wave of local waves {
	cd ${basedir}/build/input/`wave'

	///////////////////////////////////////////////////////////////////////////////
	// pull in household noncore files
	foreach k of numlist 1/5{
	use HN`k', clear
	if `wavenum'==1 {
		do labels_HN
		do valuelabels_HN
	}
	save HN`k', replace
	}
	///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	// appending all of the non core and ony keeping taxes for italy and cash
	// for spain
	use HN1, clear
	keep id survey sa0010 sa0100 im0100 hnj3800 fhnj3800 hng0710 fhng0710 
	keep if sa0100 == "ES" | sa0100 == "IT"
	save ${basedir}/build/temp/cash`wavenum'.dta, replace

	foreach k of numlist 2/5{
	use HN`k', clear
	keep id survey sa0010 sa0100 im0100 hnj3800 fhnj3800 hng0710 fhng0710
	keep if sa0100 == "ES" | sa0100 == "IT"
	append using ${basedir}/build/temp/cash`wavenum'.dta
	save ${basedir}/build/temp/cash`wavenum'.dta, replace
	}
	///////////////////////////////////////////////////////////////////////////////


	///////////////////////////////////////////////////////////////////////////////
	// merge in household files and derived household files

	foreach k of numlist 1/5{
	use H`k', clear
	if `wavenum'==1 {
		do labels_H
		do valuelabels_H
	}
	merge 1:1 id using D`k'
	drop _merge
	save ${basedir}/build/temp/HD`k'_`wavenum', replace
	}
	///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	// gets demographic info about the head of household and merges it into the household files
	foreach k of numlist 1/5{
	use P`k', clear
	if `wavenum'==1 {
		do labels_P
		do valuelabels_P
	}

	keep id hid survey sa0010 sa0100 im0100 pa0100 fpa0100 pa0200 fpa0200 ///
	ra0020 fra0020 ra0030 fra0030 ra0040 fra0040 ra0100 fra0100 ra0200 fra0200 ///
	ra0300 fra0300 ra0300_b fra0300_b ra0400 fra0400 ra0500 fra0500 pe0100a fpe0100a ///
	pf0710 fpf0710 pg0310 fpg0310

	// two heads of HH have imputed relation to head of household
	replace ra0100 = 1 if id == "AT1142112011"
	replace ra0100 = 1 if id == "LU1003400011"

	// sums value of occupational pensions
	replace pf0710 = 0 if pf0710 == .
	bysort hid: egen retqliq = total(pf0710)

	bysort im0100 hid: egen publ_pens_income = total(pg0310)

	// only keeps head of household info
	keep if ra0100 == 1

	drop id
	rename hid id

	// merges in the rest of the household data
	merge 1:1 id using ${basedir}/build/temp/HD`k'_`wavenum'
	drop _merge
	save ${basedir}/build/temp/HDP`k'_`wavenum', replace
	}

	///////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////
	// appends all MI files together
	cd ${basedir}/build/temp/
	use HDP1_`wavenum', clear
	append using HDP2_`wavenum'
	append using HDP3_`wavenum'
	append using HDP4_`wavenum'
	append using HDP5_`wavenum'

	///////////////////////////////////////////////////////////////////////////////
	// renaming credit and income variables to be similar to the SCF code

	gen htm1 = hi0600 == 1 | hi0600 == 2

	rename hc0200 hascreditline
	rename hc0300 hascreditcard
	rename hc0400 hasconsloan

	gen hascc = 0
	replace hascc = 1 if hascreditline == 1 | hascreditcard == 1

	rename hc0220 creditlinebalance

	rename hc0320 ccbalance


	gen consloanbalance1 = 0
	replace consloanbalance1 = hc0801 if hc0501a >= 3
	gen consloanbalance2 = 0
	replace consloanbalance2 = hc0802 if hc0502a >= 3
	gen consloanbalance3 = 0
	replace consloanbalance3 = hc0803 if hc0503a >= 3
	rename hc1100 consloanbalance4

	gen unsec_mort_debt1 = 0
	replace unsec_mort_debt1 = hc0801 if hc0501a <= 2
	gen unsec_mort_debt2 = 0
	replace unsec_mort_debt2 = hc0802 if hc0502a <= 2
	gen unsec_mort_debt3 = 0
	replace unsec_mort_debt3 = hc0803 if hc0503a <= 2

	gen unsec_mort_debt = unsec_mort_debt1 + unsec_mort_debt2 + unsec_mort_debt3

	foreach k of varlist consloanbalance1 consloanbalance2 consloanbalance3 consloanbalance4 ///
	ccbalance creditlinebalance {
	replace `k' = 0 if (`k' == .)
	}

	gen ccdebt = creditlinebalance + ccbalance
	gen ccdebtplus = creditlinebalance + ccbalance + consloanbalance1 + consloanbalance2 + ///
	consloanbalance3 + consloanbalance4


	// not given enough credit is 2, so counts that as denied, changed no to 2 and 
	// changes to not turned down if they were able to get credit elsewhere (hc1320)
	rename hc1300 applied
	if `wavenum'==1 {
		rename hc1310 turneddown
		replace turneddown = 1 if turneddown == 2
		replace turneddown = 2 if turneddown == 3
		replace turneddown = 2 if hc1320 == 1
	}

	rename hc1400 notapplied

	// fixes an obvious outlier in Belgium
	replace di1100 = di1100/10 if sa0100 == "BE" & sa0010 == 2296
	replace di2000 = di2000/10 if sa0100 == "BE" & sa0010 == 2296


	// regular income from different sources
	rename di1100 hh_earnings
	rename di1600 social_transfers
	rename di1500 pension_income
	rename di1200 hh_selfy
	rename hg0210 private_transfers
	rename hg0310 rental_income
	rename hg0410 investment_income
	rename hg0510 business_income
	rename hg0610 other_income

	foreach k of varlist hh_earnings social_transfers pension_income hh_selfy private_transfers ///
	rental_income investment_income business_income other_income {
	replace `k' = 0 if (`k' == .)
	}

	gen labinc = hh_earnings + social_transfers + private_transfers + publ_pens_income
	gen labincplus = labinc + hh_selfy
	replace labincplus = 0 if (labincplus == .)

	gen govfrac = social_transfers/labinc

	rename di2000 income
	gen incomenoselfy = income - hh_selfy

	rename hi0600 spendmorey
	// bought home in the past year if the purchase date (hb0700) equals the survey vintage
	gen buyhome = (hb0700 == sa0200)
	gen htm3=0
	replace htm3=1 if (spendmorey==1 | spendmorey==2) & buyhome==0
	gen htm4=0
	replace htm4=1 if (spendmorey==1 | spendmorey==2)

	// committed consumption
	foreach k of varlist hb2300 hb2001 hb2002 hb2003 hb2200 hb4001 hb4002 hb4003 hb4200 ///
	hc0110 hc1001 hc1002 hc1003 hc1200 hi0100 hi0200 hi0310 {
	replace `k' = 0 if (`k' == .)
	}

	rename hb2300 rentpmt
	gen homeloanpmt = hb2001 + hb2002 + hb2003 + hb2200 + hb4001 + hb4002 + hb4003 + hb4200
	// leases on cars and other durables
	rename hc0110 leasepmt
	gen consloanpmt = hc1001 + hc1002 + hc1003 + hc1200
	gen foodpmt = hi0100 + hi0200
	rename hi0310 privatetransferpmt

	gen committed_cons = rentpmt + homeloanpmt + leasepmt + consloanpmt + privatetransferpmt

	////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////////////////
	// renaming wealth variables to be similar to the SCF code
	foreach k of varlist hd1210 hd1110 hd1320* hd1510 hd1420 hd1520 hd1620 hd1710 ///
	hb0900 hb170* hb2100 hb370* hb4100 hb4400 hb4710 hd080* hd1010 da1000 da1110 da1120 ///
	da1130 da1131 da1140 da2100 da2101 da2102 da2103 da2104 da2105 da2106 da2107 ///
	da2108 da2109 da3001 hd1920 hb280* hb2900{
	replace `k' = 0 if (`k' == .)
	}

	rename hd1110 checking
	rename da2102 nmmf
	rename da2105 stocks
	rename da2103 bond
	rename da2104 deq
	gen houses = hb0900 + hb2801 + hb2802 + hb2803
	rename hb2900 oresre

	// designate a home equity line of credit if primary use of the loan is used
	// for debt consolidation or to cover living expenses
	gen heloc1 = 0
	replace heloc1 = hb1701 if hb1201a == 6 | hb1201a == 8
	gen heloc2 = 0
	replace heloc2 = hb1702 if hb1202a == 6 | hb1202a == 8
	gen heloc3 = 0
	replace heloc3 = hb1703 if hb1203a == 6 | hb1203a == 8
	gen heloc4 = 0
	replace heloc4 = hb3701 if hb3201a == 6 | hb3201a == 8
	gen heloc5 = 0
	replace heloc5 = hb3702 if hb3202a == 6 | hb3202a == 8
	gen heloc6 = 0
	replace heloc6 = hb3703 if hb3203a == 6 | hb3203a == 8

	// sum of all heloc
	gen heloc = heloc1 + heloc2 + heloc3 + heloc4 + heloc5 + heloc6

	// resdbt sums all mortgages and subtracts out HELOC
	gen resdbt = hb1701 + hb1702 + hb1703 + hb3701 + hb3702 + hb3703 + hb4100 + hb2100 - heloc + unsec_mort_debt
	rename da1130 vehic
	rename hd1210 cds
	gen othfin = hd1920 + hd1710
	rename hd1710 hhloan
	rename hd1620 othma
	rename hb4710 othnfin
	rename da2109 cashli
	rename da1140 bus

	rename dn3001 networth
	gen misc_illiq = othnfin
	////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////////////////
	// HICP adjustment
	// missing dates get put at the middle quarter of the fieldwork period if no
	// survey vintage. See section 9 of metadata documentation
	replace sb1000 = "2011Q1" if missing(sb1000) & sa0100 == "AT"
	replace sb1000 = "2010Q2" if missing(sb1000) & sa0100 == "BE"
	replace sb1000 = "2010Q3" if missing(sb1000) & sa0100 == "CY"
	replace sb1000 = "2011Q1" if missing(sb1000) & sa0100 == "DE"
	replace sb1000 = "2009Q1" if missing(sb1000) & sa0100 == "ES"
	replace sb1000 = "2010Q1" if missing(sb1000) & sa0100 == "FI"
	replace sb1000 = "2009Q4" if missing(sb1000) & sa0100 == "FR"
	replace sb1000 = "2009Q2" if missing(sb1000) & sa0100 == "GR"
	replace sb1000 = "2011Q2" if missing(sb1000) & sa0100 == "IT"
	replace sb1000 = "2010Q4" if missing(sb1000) & sa0100 == "LU"
	replace sb1000 = "2010Q4" if missing(sb1000) & sa0100 == "MT"
	replace sb1000 = "2010Q3" if missing(sb1000) & sa0100 == "NL"
	replace sb1000 = "2010Q2" if missing(sb1000) & sa0100 == "PT"
	replace sb1000 = "2010Q4" if missing(sb1000) & sa0100 == "SI"
	replace sb1000 = "2010Q4" if missing(sb1000) & sa0100 == "SK"
	// imports data on the HICP
	merge m:1 sb1000 using "${basedir}/build/input/hicp/HICP.dta"
	drop if _merge == 2
	drop _merge

	// balance sheet reference period is time of interview for most countries, but
	// for the three here is end of year of 2010 (IT) and 2009 (NT and FI)
	gen wealth_HICP_adj = 109.83339/HICP
	replace wealth_HICP_adj = 109.83339/110.92471 if sa0100 == "IT"
	replace wealth_HICP_adj = 109.83339/108.5486 if sa0100 == "NL"
	replace wealth_HICP_adj = 109.83339/108.5486 if sa0100 == "FI"

	// most income reference period is 2009 except ES (2007), IT (2010), and
	// MT,SI,FI (last 12 months)
	gen inc_HICP_adj = 109.83339/108.085704166667
	replace inc_HICP_adj = 109.83339/104.3602425 if sa0100 == "ES"
	replace inc_HICP_adj = 109.83339/109.83339 if sa0100 == "IT"
	// denominator is average of HICP 12 months back from center of reference period
	replace inc_HICP_adj = 109.83339/108.025559166667 if sa0100 == "GR"
	replace inc_HICP_adj = 109.83339/109.83339 if sa0100 == "MT"
	replace inc_HICP_adj = 109.83339/109.293695 if sa0100 == "SI"


	foreach k of varlist checking nmmf stocks bond deq houses oresre heloc resdbt ///
	vehic cds othfin othma othnfin cashli bus ccdebt hhloan{
	replace `k' = `k'*wealth_HICP_adj
	}

	foreach k of varlist committed_cons labinc labincplus income incomenoselfy{
	replace `k' = `k'*inc_HICP_adj
	}
	////////////////////////////////////////////////////////////////////////////////


	////////////////////////////////////////////////////////////////////////////////
	// demographic characteristics
	rename ra0300 age
	rename pa0200 edcat
	rename ra0200 female
	replace female = female - 1

	gen working = (pe0100a == 1)
	gen married = (pa0100 == 2) | (pa0100 == 3)

	// children is number of people in HH minus number of people +16 in HH
	gen children = dh0001 - dh0006

	gen famstruct = 0
	replace famstruct = 1 if (married == 0) & (children > 0)
	replace famstruct = 2 if (married == 0) & (children == 0) & (age <= 55)
	replace famstruct = 3 if (married == 0) & (children == 0) & (age > 55)
	replace famstruct = 4 if (married == 1) & (children > 0)
	replace famstruct = 4 if (married == 1) & (children == 0)

	label define famlab 1 "not married with kids" 2 "not married, no kids, under 55" 3 "not married, no kids, over 55" 4 "married with kids" 5 "married, no kids"
	label values famstruct famlab

	gen college = (edcat >= 5)

	rename hw0010 wgt

	////////////////////////////////////////////////////////////////////////////////
	gen wave = `wavenum'
	save ${basedir}/build/temp/HFCS`wavenum'.dta, replace
	
	local wavenum = `wavenum' + 1
}
