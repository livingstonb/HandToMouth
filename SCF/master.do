/* //////////////////////////////////////////////////////////////////////////////
Written by Justin Weidner, edited and re-organized by Brian
Livingston.

Computes HtM statistics for the US based on the 1989-2019 SCF surveys.
Output:
	Robustness checks 				- H2Mrobust.dta
	Robustness checks (std errors)	- H2Mrobust_stderrors.dta
	h2m estimates by year			- SCFh2m_yearly.dta


Select H2M definition in SCF/stats/code/stats.do
*/ //////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 0. Housekeeping
clear*
set maxvar 10000
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 1. Global macros for file path
// global basedir /Users/brianlivingston/Documents/GitHub/HandToMouth/SCF
// global basedir C:/Users/Brian/Documents/GitHub/HandToMouth/SCF
global basedir /media/hdd/GitHub/HandToMouth/SCF
global fulldir "${basedir}/build/input/full"
global extractdir "${basedir}/build/input/extract"
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 2. Clean survey files ("build" directory)

// Appends each year's extract and full data sets
do ${basedir}/build/code/build1_append_years.do

// Merges extract and full data sets, runs taxsim
// If taxsim isn't working, set scalar taxsim==0 in build2_merge.do
do ${basedir}/build/code/build2_merge.do

// Defines relevant variables for the HtM calculations, save cleaned dataset
do ${basedir}/build/code/build3_gendata.do

// Append replicate weights into one file
do ${basedir}/build/code/build4_replicates.do

////////////////////////////////////////////////////////////////////////////////
// 3. Compute fraction HtM ("stats" directory)
// process the the output from build directory, SCF_89_16_cleaned.dta, and
// produce final output
do ${basedir}/stats/code/stats.do

// HtM and direct survey questions
do ${basedir}/stats/code/stats_directquestions.do
