#delimit;

/*
Based on the timing model used in Kaplan et al. (2014), this file computes h2m, 
Wh2m, Ph2m, and NWh2, given the following variables:
incvar, liqvar, illiqvar, nwvar, payfreq, clim,
and optionally maxcredit, committed_cons
 */;

gen h2m 	= 0;
gen Wh2m 	= 0;
gen Ph2m 	= 0;
gen NWh2m 	= 0;
gen monthincome = incvar/12;
set trace on;
set tracedepth 1;
if strmatch("$borrowlimtype","reported")==1 {;
	gen creditlim = maxcredit;
};
else {;
	gen creditlim = clim*monthincome;
};

////////////////////////////////////////////////////////////////////////////////
* NORMAL HTM;
if strmatch("$h2mtype","normal")==1 {;
	* Hand-to-mouth;
	replace h2m = 1 if (liqvar>=0) & (liqvar<=monthincome/(2*payfreq));
	replace h2m = 1 if (liqvar<=0) & (liqvar<=monthincome/(2*payfreq)-creditlim);
	replace h2m = . if (liqvar==.|monthincome==.);
	* Wealthy hand-to-mouth;
	replace Wh2m = 1 if (h2m==1) & (illiqvar>0);
	* Poor hand-to-mouth;
	replace Ph2m = 1 if (h2m==1) & (illiqvar<=0);
	* Hand-to-mouth (net worth);
	replace NWh2m = 1 if (nwvar>=0 & nwvar<=monthincome/(2*payfreq))
		| (nwvar<=0 & nwvar<=(monthincome/(2*payfreq) - creditlim) );
};

////////////////////////////////////////////////////////////////////////////////
* COMMITTED CONSUMPTION AT BEGINNING OF PERIOD;
if strmatch("$h2mtype","commconsbeg")==1 {;
	* Hand-to-mouth;
	replace h2m = 1 if (liqvar>=0) & (liqvar<=(monthincome-committed_cons)/(2*payfreq));
	replace h2m = 1 if (liqvar<=0) & (liqvar<=(monthincome-committed_cons)/(2*payfreq)-creditlim);
	replace h2m = . if (liqvar==.|monthincome==.);
	* Wealthy hand-to-mouth;
	replace Wh2m = 1 if (h2m==1) & (illiqvar>0);
	* Poor hand-to-mouth;
	replace Ph2m = 1 if (h2m==1) & (illiqvar<=0);
	* Hand-to-mouth (net worth);
	replace NWh2m = 1 if (nwvar>=0 & nwvar<=(monthincome-committed_cons)/(2*payfreq))
		| (nwvar<=0 & nwvar<=((monthincome-committed_cons)/(2*payfreq) - creditlim) );
};
////////////////////////////////////////////////////////////////////////////////
* COMMITTED CONSUMPTION AT END OF PERIOD;
if strmatch("$h2mtype","commconsend")==1 {;
	* Hand-to-mouth;
	replace h2m = 1 if (liqvar>=0) & (liqvar-committed_cons<=monthincome/(2*payfreq));
	replace h2m = 1 if (liqvar<=0) & (liqvar-committed_cons<=monthincome/(2*payfreq)-creditlim);
	replace h2m = . if (liqvar==.|monthincome==.);
	* Wealthy hand-to-mouth;
	replace Wh2m = 1 if (h2m==1) & (illiqvar>0);
	* Poor hand-to-mouth;
	replace Ph2m = 1 if (h2m==1) & (illiqvar<=0);
	* Hand-to-mouth (net worth);
	replace NWh2m = 1 if (nwvar>=0 & nwvar-committed_cons<=monthincome/(2*payfreq))
		| (nwvar<=0 & nwvar-committed_cons<=(monthincome/(2*payfreq) - creditlim) );
};
////////////////////////////////////////////////////////////////////////////////
* FINANCIALLY FRAGILE HOUSEHOLDS;
if strmatch("$h2mtype","finfrag")==1 {;
	* Hand-to-mouth;
	replace h2m = 1 if (liqvar>=0) & (liqvar<=monthincome/(2*payfreq)+2000);
	replace h2m = 1 if (liqvar<=0) & (liqvar<=monthincome/(2*payfreq)-creditlim+2000);
	replace h2m = . if (liqvar==.|monthincome==.);
	* Wealthy hand-to-mouth;
	replace Wh2m = 1 if (h2m==1) & (illiqvar>0);
	* Poor hand-to-mouth;
	replace Ph2m = 1 if (h2m==1) & (illiqvar<=0);
	* Hand-to-mouth (net worth);
	replace NWh2m = 1 if (nwvar>=0 & nwvar<=monthincome/(2*payfreq)+2000)
		| (nwvar<=0 & nwvar<=(monthincome/(2*payfreq) - creditlim + 2000) );
};


////////////////////////////////////////////////////////////////////////////////
* ENFORCE MISSING VALUES;
replace Wh2m 	= . if h2m==.;
replace Ph2m 	= . if h2m==.;
replace NWh2m 	= . if (nwvar==.|monthincome==.);

drop monthincome creditlim;

