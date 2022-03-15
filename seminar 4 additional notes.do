*Seminar 4 additional notes : Data preparations      @author: Dr. You Zhou, Leeds University Business School

*Select codes first, then press "CTRL + D" to run them

*****************************************************************
*Note 1: pwd : display the path of the current working directory
*****************************************************************
pwd
cd

************************************************************************************************************************
*Note 2: If your code is too long and try to use "///" to break it into two lines, please select these two lines to run.
************************************************************************************************************************
display "Hello " ///
"world"

***********************************
*Note 3: import/export excel files
***********************************
clear all
input x y
32 56
26 67
36 61
33 58
29 58
end
export excel using "test.xlsx", sheet("use") firstrow(variables) replace
clear all
import excel "test.xlsx", sheet("use") firstrow clear

***********************
*Note 4: generate dates
***********************
clear all
input year month day
2010 01 3
2011 02 6
2012 03 8
end
gen date= mdy(month,day,year)
format date %td
drop month day year
gen year=year(date)
gen month=month(date)
gen day=day(date)

*********************************************
*Note 5: xtset to declare data to panel data 
*********************************************
clear all
input str20 cusip year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end  
encode cusip, generate (cusip1)
xtset cusip1 year

************************
*Note 6: drop duplicates
************************
clear all
input str20 company year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4
A 2012 1305 1.5
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end  
duplicates drop year, force

clear all
input str20 company year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4
A 2012 1305 1.5 
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end 
duplicates drop company, force

clear all
input str20 company year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4
A 2012 1305 1.5 
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end 
duplicates drop company year, force

******************
*Note 7: take lags
******************
clear all
input str20 company year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4
A 2012 1305 1.5 
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end 
gen bm_lag1_wrong=bm[_n-1] /*Don't do this. This is wrong to take lags*/
sort company year
by company: gen bm_lag1_correct=bm[_n-1] /*This is correct to take lags*/

************************************************
*Note 8: examples for merging/appending datasets
************************************************
*str20 tells Stata it is a string variable and that it could be up to 20 characters wide.
clear all
input str20 company year total_asset bm 
A 2010 1000 1.2
A 2011 1200 1.5 
A 2012 1300 1.4 
B 2010 3000 0.8
B 2011 3200 0.9 
B 2012 3300 1.2 
C 2010 600 1.6 
C 2011 900 1.8 
C 2012 800 1.3
end  
save data1.dta,replace

clear all
input year index1 index2 index3
2009 30 56 65
2010 26 67 35
2011 38 61 23
2012 39 58 13
2013 23 58 66
end
save data2.dta,replace

clear all
input str20 company year liability ratings 
A 2009 800 3.2
A 2011 1100 2.5 
A 2012 1200 6.4 
B 2010 2000 2.8
B 2011 2200 4.9 
B 2012 2300 6.2 
C 2010 300 1.8 
C 2011 500 2.8 
C 2012 600 2.3
end  
save data3.dta,replace

clear all
input str20 company year total_asset bm 
D 2011 1200 1.2
D 2012 1300 1.5 
D 2013 1500 1.6 
E 2016 3100 0.8
E 2017 3600 0.6 
E 2018 3200 1.3 
F 2009 800 1.6 
F 2011 900 1.3 
F 2012 800 1.6
end  
save data4.dta,replace

clear all
use data1.dta,replace
merge m:1 year using data2

clear all
use data1.dta,replace
merge 1:1 company year using data3

clear all
use data1.dta,replace
append  using data4

*Always check your datasets after merging or appending!!

*************************************************************
*Note 9: split the sample into subsamples based on conditions
*************************************************************
clear all
use data1.dta,replace
keep if year > 2010
keep if bm > 1.3
keep if total_asset >900

*And command "&"
clear all
use data1.dta,replace
keep if year > 2010 & bm > 1.3 & total_asset >900

/*
clear all
use  "seminar event analysis data 1", replace
keep if date > date("20200401","YMD")
save subsample1.dta,replace
*/
