libname sasdata "C:\Users\chrisshi\Desktop\SAS_Data";

proc copy in=sasdata out=work;
	select cereal_ds vif_example;
run;


title " multiple regression rating vs sugars";
proc reg data = cereal_ds ;
model rating = Sugars Fiber protein;
output out = reg_cerealout
h=lev cookd=Cookd  dffits=dffit 
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
;
quit;


proc reg data = cereal_ds ;
model rating = Fiber protein;
output out = reg_cerealout
h=lev cookd=Cookd  dffits=dffit 
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
;
quit;

proc univariate data = reg_cerealout ;
var lev cookd dffit;
run;


proc standard DATA = cereal_ds(keep = rating sugars fiber protein)
					MEAN = 0 STD = 1
					OUT = cereal_ds_z;
	var rating sugars fiber protein;
run; 

proc reg data = cereal_ds_z ;
model rating = Fiber protein;
output out = reg_cerealout predicted = c_predicted 
rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit 
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
;
quit;

proc reg data = cereal_ds ;
model rating =  sugars Fiber;
output out = reg_cerealout predicted = c_predicted 
rstudent = C_rstudent h=lev cookd=Cookd  dffits=dffit 
L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
;
quit;

data cereal_ds_b;
	set cereal_ds;
	row_no= _n_;
run;

proc reg data = cereal_ds_b ;
model rating =  sugars Fiber row_no;
quit;

proc univariate data = vif_example normaltest normal plot;
var y x1 x2;
run;

proc reg data=vif_example;
	*model y = x1;
	*model y = x2;
	model y = x1 x2/vif;
quit; 


data cereal_ds2;
set cereal_ds;
if shelf=1 then shelf1=1;
else shelf1=0;
if shelf=2 then shelf2=1;
else shelf2=0;
if shelf=3 then shelf3=1;
else shelf3=0; 
shelf2_cal =shelf2*calories;
run;

proc reg data= cereal_ds2 ;
model rating = calories shelf2_cal  shelf2/vif ;
quit;
