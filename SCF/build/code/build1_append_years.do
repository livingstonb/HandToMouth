/* Takes summary extract and full datasets for the survey years in 1989-2016
and exports SCF_89_16_extract.dta, SCF_89_16_full.dta to temp folder
*/

clear

// directory of extract data
cd ${extractdir}

////////////////////////////////////////////////////////////////////////////////
//append extract data together for all of the years and puts the survey year
use rscfp2016.dta
gen year = 2016
append using rscfp2013.dta
replace year = 2013 if year == .
append using rscfp2010.dta
replace year = 2010 if year == .
append using rscfp2007.dta
replace year = 2007 if year == .
append using rscfp2004.dta
replace year = 2004 if year == .
append using rscfp2001.dta
replace year = 2001 if year == .
append using rscfp1998.dta
replace year = 1998 if year == .
append using rscfp1995.dta
replace year = 1995 if year == .
append using rscfp1992.dta
replace year = 1992 if year == .
append using rscfp1989.dta
replace year = 1989 if year == .

replace Y1 = X1 if year == 1989
replace YY1 = XX1 if year == 1989

cd ${basedir}/build/temp
save SCF_89_16_extract.dta, replace

clear

//append full data together for all of the years and puts the survey year
cd ${fulldir}
//merges full data
use p16i6.dta
gen year = 2016
append using p13i6.dta
replace year = 2013 if year == .
append using p10i6.dta
replace year = 2010 if year == .
append using p07i6.dta
replace year = 2007 if year == .
append using p04i6.dta
replace year = 2004 if year == .
append using p01i6.dta
replace year = 2001 if year == .
append using p98i6.dta
replace year = 1998 if year == .
append using p95i6.dta
replace year = 1995 if year == .
append using p92i4.dta
replace year = 1992 if year == .
append using p89i6.dta
replace year = 1989 if year == .

replace Y1 = X1 if year == 1989
replace YY1 = XX1 if year ==1989

cd ${basedir}/build/temp
save SCF_89_16_full.dta, replace
///////////////////////////////////////////////////////////////////////////////
