#delimit;

/* This is the main do-file to compute hand-to-mouth statistics for the
CEX. Code written by Brian Livingston. */;

/* CAUTION: BECAUSE OF THE WAY THIS CODE DEALS WITH MULTIPLE IMPUTATIONS,
OUTPUT DIRECTORY WILL BE AT LEAST 8 GBs */;

////////////////////////////////////////////////////////////////////////////////
clear*;
set more 1;
global basedir /Users/Brian/Documents/GitHub/HandToMouth/CEX;

////////////////////////////////////////////////////////////////////////////////
* BUILD DIRECTORY;
do ${basedir}/build/code/build1_fmli_appendyears.do;
do ${basedir}/build/code/build2_fmli_vars.do;

////////////////////////////////////////////////////////////////////////////////
* STATS DIRECTORY;
do ${basedir}/stats/code/stats.do;
