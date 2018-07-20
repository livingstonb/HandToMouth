clear
* cap log close
set more off

* cap log close
* log using $BaseDir/create1e_readind.log,replace t

*This is the individual data set
*keep first family number, then sequence number, then relationship to head
*Note: there's no relationship to head in the first year of data

cd $BaseDir/build/input
u ind2011er/ind2011er, clear

#delimit;
keep  ER30001 ER30020 ER30043 ER30067 ER30091 ER30117 ER30138 ER30160 ER30188 ER30217 ER30246 ER30283 ER30313 ER30343 
      ER30373 ER30399 ER30429 ER30463 ER30498 ER30535 ER30570 ER30606 ER30642 ER30689 ER30733 ER30806 ER33101 ER33201
	ER33301 ER33401 ER33501 ER33601 ER33701 ER33801 ER33901 ER34001 ER34101		/* IntERview numbER */
        ER30021 ER30044 ER30068 ER30092 ER30118 ER30139 ER30161 ER30189 ER30218 ER30247 ER30284 ER30314 ER30344 
      ER30374 ER30400 ER30430 ER30464 ER30499 ER30536 ER30571 ER30607 ER30643 ER30690 ER30734 ER30807 ER33102 ER33202
	ER33302 ER33402	ER33502 ER33602 ER33702 ER33802 ER33902 ER34002 ER34102 	/* Sequence numbER */
      	 ER30003 ER30022 ER30045 ER30069 ER30093 ER30119 ER30140 ER30162 ER30190 ER30219 ER30248 ER30285 ER30315 
	ER30345 ER30375 ER30401 ER30431 ER30465 ER30500 ER30537 ER30572 ER30608 ER30644 ER30691 ER30735 ER30808 ER33103
	ER33203 ER33303 ER33403 ER33503 ER33603 ER33703 ER33803 ER33903 ER34003 ER34103;	 /* Relationship to Head */

drop if ER30001>=7001 & ER30001<=9308; /*Drop latino households*/

gen seo=ER30001>=5000 & ER30001<=7000; 
/* ER30001:  1-2930 means 1968 SRC sample;  
          3001-3511 means 1997/1999 Immigrant sample;
          5001-6872 means 1968 Census sample;
          7001-9308 means 1990/1992 Latino sample */

drop if   ER30003!=1  & ER30022!=1  & ER30045!=1  & ER30069!=1  & ER30093!=1 
        & ER30119!=1  & ER30140!=1  & ER30162!=1  & ER30190!=1  & ER30219!=1 
        & ER30248!=1  & ER30285!=1  & ER30315!=1  & ER30345!=1  & ER30375!=1 
        & ER30401!=10 & ER30431!=10 & ER30465!=10 & ER30500!=10 & ER30537!=10 
        & ER30572!=10 & ER30608!=10 & ER30644!=10 & ER30691!=10 & ER30735!=10
        & ER30808!=10 & ER33103!=10 & ER33203!=10 & ER33303!=10 & ER33403!=10
        & ER33503!=10 & ER33603!=10 & ER33703!=10 & ER33803!=10 & ER33903!=10
        & ER34003!=10 & ER34103!=10;	/*Drop those who are nevER heads*/

/* year intERview numbERs */
#delimit cr
ren ER30001 intid1968
ren ER30020 intid1969
ren ER30043 intid1970
ren ER30067 intid1971 
ren ER30091 intid1972 
ren ER30117 intid1973 
ren ER30138 intid1974
ren ER30160 intid1975
ren ER30188 intid1976
ren ER30217 intid1977
ren ER30246 intid1978
ren ER30283 intid1979
ren ER30313 intid1980
ren ER30343 intid1981
ren ER30373 intid1982
ren ER30399 intid1983
ren ER30429 intid1984
ren ER30463 intid1985
ren ER30498 intid1986
ren ER30535 intid1987
ren ER30570 intid1988
ren ER30606 intid1989
ren ER30642 intid1990
ren ER30689 intid1991
ren ER30733 intid1992
ren ER30806 intid1993
ren ER33101 intid1994
ren ER33201 intid1995
ren ER33301 intid1996
ren ER33401 intid1997
ren ER33501 intid1999
ren ER33601 intid2001
ren ER33701 intid2003
ren ER33801 intid2005
ren ER33901 intid2007
ren ER34001 intid2009
ren ER34101 intid2011

/*generate head dummies*/
gen pid1968=ER30003==1 /*head in 1968*/
gen pid1969=ER30022==1  & ER30021>=1 & ER30021<=20 /*in family head 1969*/
gen pid1970=ER30045==1  & ER30044>=1 & ER30044<=20
gen pid1971=ER30069==1  & ER30068>=1 & ER30068<=20
gen pid1972=ER30093==1  & ER30092>=1 & ER30092<=20
gen pid1973=ER30119==1  & ER30118>=1 & ER30118<=20 
gen pid1974=ER30140==1  & ER30139>=1 & ER30139<=20 
gen pid1975=ER30162==1  & ER30161>=1 & ER30161<=20 
gen pid1976=ER30190==1  & ER30189>=1 & ER30189<=20 
gen pid1977=ER30219==1  & ER30218>=1 & ER30218<=20 
gen pid1978=ER30248==1  & ER30247>=1 & ER30247<=20 
gen pid1979=ER30285==1  & ER30284>=1 & ER30284<=20 
gen pid1980=ER30315==1  & ER30314>=1 & ER30314<=20 
gen pid1981=ER30345==1  & ER30344>=1 & ER30344<=20 
gen pid1982=ER30375==1  & ER30374>=1 & ER30374<=20 
gen pid1983=ER30401==10 & ER30400>=1 & ER30400<=20
gen pid1984=ER30431==10 & ER30430>=1 & ER30430<=20
gen pid1985=ER30465==10 & ER30464>=1 & ER30464<=20
gen pid1986=ER30500==10 & ER30499>=1 & ER30499<=20
gen pid1987=ER30537==10 & ER30536>=1 & ER30536<=20
gen pid1988=ER30572==10 & ER30571>=1 & ER30571<=20
gen pid1989=ER30608==10 & ER30607>=1 & ER30607<=20
gen pid1990=ER30644==10 & ER30643>=1 & ER30643<=20
gen pid1991=ER30691==10 & ER30690>=1 & ER30690<=20
gen pid1992=ER30735==10 & ER30734>=1 & ER30734<=20
gen pid1993=ER30808==10 & ER30807>=1 & ER30807<=20
gen pid1994=ER33103==10 & ER33102>=1 & ER33102<=20
gen pid1995=ER33203==10 & ER33202>=1 & ER33202<=20
gen pid1996=ER33303==10 & ER33302>=1 & ER33302<=20
gen pid1997=ER33403==10 & ER33402>=1 & ER33402<=20
gen pid1999=ER33503==10 & ER33502>=1 & ER33502<=20
gen pid2001=ER33603==10 & ER33602>=1 & ER33602<=20
gen pid2003=ER33703==10 & ER33702>=1 & ER33702<=20
gen pid2005=ER33803==10 & ER33802>=1 & ER33802<=20
gen pid2007=ER33903==10 & ER33902>=1 & ER33902<=20
gen pid2009=ER34003==10 & ER34002>=1 & ER34002<=20
gen pid2011=ER34103==10 & ER34102>=1 & ER34102<=20

keep intid* pid* seo

gen person=1
replace person=sum(person)
reshape long intid pid,i(person seo) j(year)
//replace year=1900+year

/*drop people who are no heads in that year*/
drop if pid==0

cd $BaseDir/build/temp
save person,replace

clear

cd $BaseDir/build/temp
u fam1c,clear
sort intid year
save PSIDfam, replace

cd $BaseDir/build/temp
u person,clear
compress
sort intid year
merge intid year using fam1c
tab _merge
drop if _merge!=3
drop _merge

cd $BaseDir/build/output
save PSIDperson, replace

* log close
