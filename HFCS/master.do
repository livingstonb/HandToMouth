#delimit;
clear;

global basedir /Users/Brian/Documents/GitHub/HandToMouth/HFCS;

* To save HICP data as .dta, use: ;
*import excel sb1000 HICP using HICP.xlsx, sheet("out") cellrange(A2:B106);

* do ${basedir}/build/code/build1_mergevar;
* do ${basedir}/build/code/build2_gendata;

local countries FR DE IT ES;
local count = 0;
foreach ct of local countries {;
	global country `ct';
	do ${basedir}/stats/code/stats.do;
	clear;
	
	if `count'==0 {;
		matrix sampleN = samplesize;
	};
	else {;
		matrix sampleN = sampleN,samplesize;
	};
	local count = `count' + 1;
};


matrix colnames sampleN = `countries';
svmat sampleN, names(col);
outsheet using ${basedir}/stats/output/N.csv, comma replace;
