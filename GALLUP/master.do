#delimit;

/* This is the main do-file to compute hand-to-mouth statistics for 
GALLUP US Daily. Code written by Brian Livingston. */;

////////////////////////////////////////////////////////////////////////////////
clear*;
set more 1;
// global basedir /Users/Brian/Documents/GitHub/HandToMouth/GALLUP;
global basedir D:\GitHub\HandToMouth\GALLUP;

////////////////////////////////////////////////////////////////////////////////
* BUILD DIRECTORY;
do ${basedir}/build/code/build1_cleanyears.do;
do ${basedir}/build/code/build2_appendyears.do;

////////////////////////////////////////////////////////////////////////////////
* STATS DIRECTORY;
do ${basedir}/stats/code/stats.do;
