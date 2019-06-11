* Stata code to analyse GBD estimates for NCD mortality 30-70 and 70-90 years

* data source: GBD 2017, available from http://ghdx.healthdata.org/gbd-results-tool

use GBD_age_spec_NCD_mortality, replace
set more off

* collapse dataset by adding the 4 NCD causes to give overall NCD mortality
collapse (sum) mort_rate_1000, by(WHO_region country sex agegp year)

* generate absolute mortality rate
gen mort_rate=mort_rate_1000/1000

* generate 5qx values
gen p_surv=1-(mort_rate*5/(1+(mort_rate*2.5)))

* convert from 28080 long-form data records to 2340 wide-form
gen p_surv_30_34=p_surv if agegp=="30 to 34"
gen p_surv_35_39=p_surv if agegp=="35 to 39"
gen p_surv_40_44=p_surv if agegp=="40 to 44"  
gen p_surv_45_49=p_surv if agegp=="45 to 49"
gen p_surv_50_54=p_surv if agegp=="50 to 54"  
gen p_surv_55_59=p_surv if agegp=="55 to 59"
gen p_surv_60_64=p_surv if agegp=="60 to 64"
gen p_surv_65_69=p_surv if agegp=="65 to 69"
gen p_surv_70_74=p_surv if agegp=="70 to 74"  
gen p_surv_75_79=p_surv if agegp=="75 to 79"
gen p_surv_80_84=p_surv if agegp=="80 to 84"  
gen p_surv_85_89=p_surv if agegp=="85 to 89"
collapse (sum) p_surv_30_34 p_surv_35_39 p_surv_40_44 p_surv_45_49 p_surv_50_54 p_surv_55_59 p_surv_60_64 ///
  p_surv_65_69 p_surv_70_74 p_surv_75_79 p_surv_80_84 p_surv_85_89, by(WHO_region country sex year)

* gen q_40_30 q_70_20 and q_70_20/q_40_30 ratio
gen q_40_30=1-(p_surv_30_34*p_surv_35_39*p_surv_40_44*p_surv_45_49*p_surv_50_54*p_surv_55_59*p_surv_60_64*p_surv_65_69)
gen q_70_20=1-(p_surv_70_74*p_surv_75_79*p_surv_80_84*p_surv_85_8)
gen ratio=q_70_20/q_40_30
drop p_surv*

* save outcomes as .xls file
export excel using analysis_data.xls, firstrow(variables) replace

* fit curve for Figure 1
curvefit ratio q_40_30, nograph function(1 2 3 4 5 6 7 8)

* plot Figure 1
twoway scatter ratio q_40_30, ///
 legend(off) ///
 xtitle("probability of dying aged 30-69 yrs") ///
 ytitle("ratio of probability of dying aged 70-89 yrs : 30-69 yrs") ///
 yscale(range(0 8)) ylabel(0 2 4 6 8, nogrid) xlabel(0 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5") ///
 || function y=1.31*(x^-0.592), range(0.050 0.55) lcolor(red)
graph export figure_1.pdf, as(pdf) replace

* fit curves for Figure 2a
curvefit ratio q_40_30 if sex=="Female", nograph function(6)
curvefit ratio q_40_30 if sex=="Male", nograph function(6)
* plot Figure 2a
twoway scatter ratio q_40_30 if sex=="Female", mcolor(red) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 legend(pos(2) ring(0) cols(1) order(3 4) label(3 females) label(4 males)) ///
 xtitle("probability of dying aged 30-69 yrs")  title("by sex:", pos(10) ring(0)) ///
 ytitle("ratio of probability of dying aged 70-89 yrs : 30-69 yrs") ///
 yscale(range(0 8)) ylabel(0 2 4 6 8, nogrid) xlabel(0 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5") ///
 || scatter ratio q_40_30 if sex=="Male", mcolor(blue) mfcolor(none) msize(vsmall) msize(vsmall) mlwidth(medthin) ///
 || function y=1.39*(x^-0.565), range(0.065 0.55) lcolor(red) ///
 || function y=1.21*(x^-0.645), range(0.065 0.55) lcolor(blue)
graph save graph_2a, replace

* fit curves for Figure 2a
curvefit ratio q_40_30 if year==1992, nograph function(6)
curvefit ratio q_40_30 if year==1997, nograph function(6)
curvefit ratio q_40_30 if year==2002, nograph function(6)
curvefit ratio q_40_30 if year==2007, nograph function(6)
curvefit ratio q_40_30 if year==2012, nograph function(6)
curvefit ratio q_40_30 if year==2017, nograph function(6)
* plot Figure 2a
twoway scatter ratio q_40_30 if year==1992, mcolor(gs12) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 legend(pos(2) ring(0) cols(1) order(7 8 9 10 11 12) /// 
 label(7 1992) label(8 1997) label(9 2002) label(10 2007) label(11 2012) label(12 2017)) ///
 xtitle("probability of dying aged 30-69 yrs")  title("by year:", pos(10) ring(0)) ///
 ytitle("ratio of probability of dying aged 70-89 yrs : 30-69 yrs") ///
 yscale(range(0 8)) ylabel(0 2 4 6 8, nogrid) xlabel(0 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5") ///
 || scatter ratio q_40_30 if year==1997, mcolor(gs11) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if year==2002, mcolor(gs10) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if year==2007, mcolor(gs9) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if year==2012, mcolor(gs7) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if year==2017, mcolor(gs5) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || function y=1.16*(x^-0.683), range(0.065 0.55) lcolor(gs12) ///
 || function y=1.17*(x^-0.670), range(0.065 0.55) lcolor(gs11) ///
 || function y=1.21*(x^-0.648), range(0.065 0.55) lcolor(gs10) ///
 || function y=1.28*(x^-0.608), range(0.065 0.55) lcolor(gs9) ///
 || function y=1.35*(x^-0.571), range(0.065 0.55) lcolor(gs7) ///
 || function y=1.42*(x^-0.540), range(0.065 0.55) lcolor(gs5)
graph save graph_2b, replace 

* fit curves for Figure 2c
curvefit ratio q_40_30 if WHO_region=="AFRO", nograph function(6)
curvefit ratio q_40_30 if WHO_region=="AMRO", nograph function(6)
curvefit ratio q_40_30 if WHO_region=="EMRO", nograph function(6)
curvefit ratio q_40_30 if WHO_region=="EURO", nograph function(6)
curvefit ratio q_40_30 if WHO_region=="SEAR", nograph function(6)
curvefit ratio q_40_30 if WHO_region=="WPRO", nograph function(6)
* plot Figure 2c
twoway scatter ratio q_40_30 if WHO_region=="AFRO", mcolor(red) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 legend(pos(2) ring(0) cols(1) order(7 8 9 10 11 12) ///
 label(7 "AFRO") label(8 "AMRO") label(9 "EMRO") label(10 "EURO") label(11 "SEARO") label(12 "WPRO")) ///
 xtitle("probability of dying aged 30-69 yrs")  title("by WHO Region:", pos(10) ring(0)) ///
 ytitle("ratio of probability of dying aged 70-89 yrs : 30-69 yrs") ///
 yscale(range(0 8)) ylabel(0 2 4 6 8, nogrid) xlabel(0 0.1 "0.1" 0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5") ///
 || scatter ratio q_40_30 if WHO_region=="AMRO", mcolor(khaki) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if WHO_region=="EMRO", mcolor(orange) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if WHO_region=="EURO", mcolor(blue) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if WHO_region=="SEAR", mcolor(cyan) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || scatter ratio q_40_30 if WHO_region=="WPRO", mcolor(magenta) mfcolor(none) msize(vsmall) mlwidth(medthin) ///
 || function y=1.08*(x^-0.698), range(0.065 0.55) lcolor(red) ///
 || function y=1.43*(x^-0.518), range(0.065 0.55) lcolor(khaki) ///
 || function y=1.40*(x^-0.547), range(0.065 0.55) lcolor(orange) ///
 || function y=1.51*(x^-0.561), range(0.065 0.55) lcolor(blue) ///
 || function y=1.53*(x^-0.480), range(0.065 0.55) lcolor(cyan) ///
 || function y=1.35*(x^-0.562), range(0.065 0.55) lcolor(magenta)
graph save graph_2c, replace

* combine 2a, 2b, 2c into a single Figure 2
graph combine graph_2a.gph graph_2b.gph graph_2c.gph, cols(1) ysize(16) xsize(8) iscale(.7)
graph export figure_2.pdf, as(pdf) replace


