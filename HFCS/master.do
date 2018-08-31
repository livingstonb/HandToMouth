#delimit;
clear;

global basedir /Users/brianlivingston/Documents/GitHub/HandToMouth/HFCS;

* To save HICP data as .dta, use: ;
*import excel sb1000 HICP using HICP.xlsx, sheet("out") cellrange(A2:B106);

do ${basedir}/build/code/build1_mergevar;
do ${basedir}/build/code/build2_gendata;

* FR must be first, otherwise must change loop_h2m;
local countries FR DE IT ES;
foreach ct of local countries {;
	global country `ct';
	do ${basedir}/stats/code/stats.do;
	clear;
};

matrix rownames samplesize = `countries';
svmat samplesize, names(col);
