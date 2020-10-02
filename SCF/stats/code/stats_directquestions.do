//////////////////////////////////////////////////////////////////////////////
#delimit;
set more 1;
cd $basedir/build/output;
use SCF_89_19_cleaned.dta, clear;
cap mkdir $basedir/stats/output;

/* This file computes hand-to-mouth statistics from direct survey questions
for the SCF.*/;

////////////////////////////////////////////////////////////////////////////////
* SAMPLE SELECTION;
keep if (age>=22) & (age<=79);

////////////////////////////////////////////////////////////////////////////////
* STATISTICS;

/* Over the past year, would you say that your (family's) spending exceeded your 
(family's) income, that it was about the same as your income, or that you spent 
less than your income? -- copied from Justin Weidner's code */;
gen spendmore_h2m = .;
replace spendmore_h2m = 0 if spendmorey == 3;
replace spendmore_h2m = 1 if (spendmorey==1 | spendmorey==2) & (buyhome==5 | buyhome == 0);
replace spendmore_h2m = 1 if (spendmorey==1 | spendmorey==2) & buyhome==1 & (spendexceedy == 1 | spendexceedy == 2);
replace spendmore_h2m = 0 if (spendmorey==1 | spendmorey==2) & buyhome==1 & (spendexceedy == 3 | spendexceedy == 0);

/* Don't save - usually spend more than income OR don't save - usually spend
as much as income */;
gen usuallyspend_h2m = 0;
replace usuallyspend_h2m = 1 if nosavebor==1 | nosavezero==1;

////////////////////////////////////////////////////////////////////////////////
* ESTIMATE MEAN AND VARIANCE;
cd ${basedir}/build/temp;
merge m:1 YY1 year using replicates.dta, nogen;
gen rep = im0100;

scfcombo spendmore_h2m [aw=wgt], command(regress) reps(400) imps(5);
matrix h2m_b = e(b);
matrix h2m_V = e(V);

scfcombo usuallyspend_h2m [aw=wgt], command(regress) reps(400) imps(5);
matrix h2m_b = h2m_b,e(b);
matrix h2m_V = h2m_V,e(V);

matrix direct_questions = h2m_b\h2m_V;
matrix colnames direct_questions = spendmore usualspendm;
matrix rownames	direct_questions = b Var;
matrix list direct_questions;
