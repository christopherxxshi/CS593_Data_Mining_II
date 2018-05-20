libname "C:\Users\chrisshi\Desktop\SAS_Data";
proc copy in=sasdata out=work;
	select Character_matrix;
run;


proc sql;
 create table numerator as
 	select count(*) as numerator 
	from Character_matrix
	where doc5 = 1 and doc6 = 1;
quit;

proc sql;
 create table denom as
 	select count(*) as denom 
	from Character_matrix
	where doc5 = 1 or doc6 = 1;
quit;

proc sql;
 create table similar as
 	select a.numerator/b.denom as similar 
	from numerator a, denom b;
quit;
