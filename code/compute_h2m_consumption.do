#delimit;
cap drop h2m Wh2m Ph2m NWh2m;


////////////////////////////////////////////////////////////////////////////////
* NON-DURABLE CONSUMPTION & H2M;
gen h2m 	= (con*1.2 >= incvar) & (nwvar <= 0);
gen Wh2m 	= (h2m==1) & (illiqvar >= 0);
gen Ph2m	= (h2m==1) & (Wh2m==0); 

////////////////////////////////////////////////////////////////////////////////
* ENFORCE MISSING VALUES;
replace h2m 	= . if (con==.)|(incvar==.)|(liqvar==.);
replace Wh2m 	= . if h2m==.;
replace Ph2m 	= . if h2m==.;

