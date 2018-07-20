/* //////////////////////////////////////////////////////////////////////////////
Written by Justin Weidner, edited and re-organized by Brian
Livingston.

Computes HtM statistics for the US based on the 1989-2016 SCF surveys.
Final output stored in SCF/stats/output
Select H2M definition in SCF/stats/code/stats.do
*/ //////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 0. Housekeeping
clear*
set maxvar 10000
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 1. Global macros for file paths
// Change rawdir to the appropriate file path
* global basedir "/Users/brianlivingston/Documents/GitHub/HtM/SCF"
global basedir /Users/Brian/Desktop/HtM/SCF

global fulldir "${basedir}/build/input/full"
global extractdir "${basedir}/build/input/extract"
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// 2. Clean survey files ("build" directory)
// requires extract and full datasets for 1989-2016

// Appends each year's extract and full data sets
do ${basedir}/build/code/build1_append_years.do

// Merges extract and full data sets, runs taxsim
// If taxsim isn't working, set scalar taxsim==0 in build2_merge.do
do ${basedir}/build/code/build2_merge.do

// Defines relevant variables for the HtM calculations, save cleaned dataset
do ${basedir}/build/code/build3_gendata.do

////////////////////////////////////////////////////////////////////////////////
// 3. Compute fraction HtM ("stats" directory)
// requires output from build directory

// process the the output from build directory, SCF_89_16_cleaned.dta, and
// produce final output
do ${basedir}/stats/code/stats.do

