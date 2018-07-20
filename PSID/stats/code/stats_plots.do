#delimit;


////////////////////////////////////////////////////////////////////////////////
* H2M VS AGE;
* Plot h2m by age;
cd $BaseDir/../code;
do plot_h2m_age.do;
cd $BaseDir/stats/output;
graph export PSID_h2m_age.png, replace;


