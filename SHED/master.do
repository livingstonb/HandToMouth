#delimit;
clear*;
set more 1;

/* Computes hand-to-mouth statistics for the Survey of Household Economics and  
Decisionmaking. Written by Brian Livingston. */;

/* NOTE: VARIABLES NOT INCLUDED IN FINAL ANALYSIS (stats.do) MAY BE CODED 
DIFFERENTLY FOR YEARS < 2017, CHECK CODEBOOKS*/;

////////////////////////////////////////////////////////////////////////////////
* Main directory;
global basedir /Users/Brian/Documents/GitHub/HtM/SHED;

////////////////////////////////////////////////////////////////////////////////
* BUILD DIRECTORY;
* Build dataset;
cd ${basedir}/build/code;
do build.do;
* Clean;
cd ${basedir}/build/code;
do build_missing.do;

////////////////////////////////////////////////////////////////////////////////
* Compute HtM statistics;
cd ${basedir}/stats/code;
do stats.do;
