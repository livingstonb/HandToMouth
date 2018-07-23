#delimit;
cap drop h2m Wh2m Ph2m NWh2m;

/* Computes hand-to-mouth statistics based on c >= y and liqvar <= 0 */;

////////////////////////////////////////////////////////////////////////////////
* NON-DURABLE CONSUMPTION & H2M;
gen h2m 	= (con >= incvar); * & (liqvar <= incvar/(2*12));

////////////////////////////////////////////////////////////////////////////////
* ENFORCE MISSING VALUES;
replace h2m 	= . if (con==.)|(incvar==.)|(liqvar==.);


