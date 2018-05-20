libname sasdata "C:\Users\chrisshi\Desktop\SAS_Data";

proc copy in=sasdata out=work;
	select depression lung;
run;

proc reg data = lung;
model FVC_father = Age_father Weight_father; 
run;

title " " ;
proc reg data = depression;
model cat_total = income age sex;
run;

proc reg data = lung;
model height_oldest_child =  age_oldest_child weight_oldest_child height_father;
run;
