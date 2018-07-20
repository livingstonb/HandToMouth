#delimit;


////////////////////////////////////////////////////////////////////////////////
* H2M VS AGE;
* Plot h2m by age;
cd $basedir/../code;
do plot_h2m_age.do;
cd $basedir/stats/output;
graph export PSID_h2m_age.png, replace;


* Plot h2m by year;
cd $basedir/../code;
do plot_h2m_year.do;
cd $basedir/stats/output;
graph export PSID_h2m_year.png, replace;
