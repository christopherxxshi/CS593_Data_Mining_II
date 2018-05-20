libname "C:\Users\chrisshi\Desktop\SAS_Data";

proc copy in=sasdata out=work;
	select cereal_ds;
run;

proc univariate data = cereal_ds normal;
var sugars;
run;

title "Simple Regression for rating vs sugars";
proc reg data = cereal_ds;
model rating = sugars /;
quit;

title "Simple Regression for rating vs sugars";
proc reg data = cereal_ds;
model rating = sugars /;
quit;
