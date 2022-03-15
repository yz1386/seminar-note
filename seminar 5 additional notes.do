*Seminar 5 additional notes : Basic descriptive analysis & Stata Loops and Marco introduction   @author: Dr. You Zhou, Leeds University Business School

*********************************
*note 1: prepare examples data
*********************************
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
input str20 company year total_asset bm liability ratings 
D 2011 1200 1.2 3200 0.3
D 2012 1300 1.5 2800 0.6
D 2013 1500 1.6 3000 0.5
E 2016 3100 0.8 1200 1.6
E 2017 3600 0.6 1500 1.8
E 2018 3200 1.3 1800 1.6
F 2009 800 1.6  5000 3
F 2011 900 1.3  6000 2.8
F 2012 800 1.6  6600 2.6
F 2013 860 1.8  6800 3
end  
save data4.dta,replace

clear all
use data1.dta,replace
merge 1:1 company year using data3
keep if _merge == 3
drop _merge

append  using data4

save example.dta,replace

*Always check your datasets after merging or appending!!

*********************************
*note 2: set lables for variables to make output 
*********************************
use example.dta,clear

label var total_asset "Total assets"
label var bm "Book-to-Market ratio"
label var liability "Total liability"
label var ratings "Ratings"

save example.dta,replace

*********************************
*note 3: summary and output it
*********************************
use example.dta,clear

sum

sum total_asset bm liability ratings, detail

*install the command outreg2
ssc install outreg2

capture erase sum.xls
capture erase sum.txt
set matsize 10000
outreg2 using sum.xls, replace sum(detail) keep( total_asset bm liability ratings) eqkeep( N mean sum sd min p25 p50 p75 max)  label

*********************************************
*note 4: calculate correlations and output it
*********************************************
use example.dta,clear

*install the command asdoc
ssc install asdoc

corr total_asset bm liability ratings

* output using word file
capture erase  Myfile.doc
asdoc cor total_asset bm liability ratings

capture erase  Myfile.doc
asdoc cor total_asset bm liability ratings, label replace

capture erase  Myfile.doc
asdoc pwcorr total_asset bm liability ratings, star(all) label replace nonum

* output using excel files
capture erase  correlations.xlsx
putexcel set correlations.xlsx, modify
corr total_asset bm liability ratings
return list
matrix list r(C)
putexcel A1=matrix(r(C)), names

*find the correlations.xlsx in your working directory using "pwd" command
pwd

**********************
*note 5 : STATA macro
**********************

use example.dta,clear

reg total_asset bm liability ratings

*global vs. local

* If I define global macro once,  I could run each line using this global macro
global my_var1 "bm"

reg total_asset bm 

reg total_asset $my_var1 

reg total_asset bm liability ratings

reg total_asset $my_var1 liability ratings


*If I define local macro, I should select two lines (local + reg) to run in order to use this local macro.
*try to select two lines to run, then see what happens if you only select the reg line to run

local my_var2 "liability"
reg total_asset `my_var2'

local my_var2 "liability" 
reg total_asset bm  `my_var2' ratings

local my_var3 "ratings"
reg total_asset `my_var3' 

local my_var3 "ratings"
reg total_asset bm liability `my_var3' 


***********************
*note 6 : STATA loops
***********************

use example.dta,clear

egen firm_id = group(company)

* If you want to check the summary statistics for each company, let's write the code for each company and write a STATA loop.
* which one would make your code more efficient?

*1.run code for each company
sum if firm_id == 1
sum if firm_id == 2
sum if firm_id == 3
sum if firm_id == 4
sum if firm_id == 5
sum if firm_id == 6


*2.using a STATA loop process
forvalues i = 1/6 {    
sum if firm_id == `i'
}

