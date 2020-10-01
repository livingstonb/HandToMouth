#delimit;
clear*;
set maxvar 30000;
set more 1;

/* This is the main do-file for computing hand-to-mouth statistics in the PSID.*/;

global basedir /media/hdd/GitHub/HandToMouth/PSID ;

////////////////////////////////////////////////////////////////////////////////
* BUILD DIRECTORY;
* Get consumption data from family dataset;
cd ${basedir}/build/code;
do build1a_readfam.do;
cd $basedir/build/code;
do build1b_topcoding.do;
cd $basedir/build/code;
do build1c_makeannual.do;

* Get wealth data from family and wealth datasets;
cd $basedir/build/code;
do build2a_wealthfam.do;
cd $basedir/build/code;
do build2b_wealth.do;
cd $basedir/build/code;
do build2c_mergewealth.do;
cd $basedir/build/code;
do build2d_topcoding.do;

* Run taxsim9;
cd $basedir/build/code;
do build3_ftax.do;

* Merge consumption and wealth datasets, create new variables;
cd $basedir/build/code;
do build4_mergefinal_newvars.do;

////////////////////////////////////////////////////////////////////////////////
* STATS DIRECTORY;
cd $basedir/stats/code;
do stats.do;
