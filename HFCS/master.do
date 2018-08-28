#delimit;
clear;

global basedir /Users/brianlivingston/Documents/GitHub/HandToMouth/HFCS;

local countries FR GR IT ES;
foreach ct of local countries {;
	global country `ct';
	do ${basedir}/stats/stats.do;
};
