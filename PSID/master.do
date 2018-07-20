#delimit;
clear*;
set maxvar 30000;

* global BaseDir /Users/brianlivingston/Documents/GitHub/HtM/PSID ;
global BaseDir /Users/Brian/Desktop/HtM/PSID ;

////////////////////////////////////////////////////////////////////////////////
* FAMILY DATA - CONSUMPTION;
cd $BaseDir/build/code;
do build1a_readfam.do;
cd $BaseDir/build/code;
do build1b_topcoding.do;
cd $BaseDir/build/code;
do build1c_makeannual.do;

////////////////////////////////////////////////////////////////////////////////
* FAMILY AND WEALTH DATA - WEALTH;
cd $BaseDir/build/code;
do build2a_wealthfam.do;
cd $BaseDir/build/code;
do build2b_wealth.do;
cd $BaseDir/build/code;
do build2c_mergewealth.do;
cd $BaseDir/build/code;
do build2d_ftax.do;


////////////////////////////////////////////////////////////////////////////////
* MERGE CONSUMPTION AND WEALTH, CREATE NEW VARIABLES;
cd $BaseDir/build/code;
do build3_mergefinal_newvars.do;

////////////////////////////////////////////////////////////////////////////////
* STATS;
cd $BaseDir/stats/code;
do stats.do;
