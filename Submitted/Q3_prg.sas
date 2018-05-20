libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
* copy dataset from sasdata to work;
proc copy in=sasdata out=work;
	select depression;
run;
* original regression model;
proc reg data = depression;
model cat_total = income sex age /vif;
OUTPUT OUT=depression_reg  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit;
quit;
*delete top 15 cook's d observations by sql;
proc sql;
create table top_cookd as
	select * 
	from depression_reg
	order by cookd DESC;
run;
proc sql;
create table depression_cookd as
	select * 
	from depression_reg as a
	where a.id not in (
	select id
	from top_cookd(obs=15)
);
run;
quit;
* train new model;
proc reg data = depression_cookd;
model cat_total = income sex age /vif ;
OUTPUT OUT=depression_reg  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit;
quit;

*delete top 15 leverage observations by sql;
proc sql;
create table top_leverage as
	select * 
	from depression_reg
	order by lev DESC;
run;
proc sql;
create table depression_leverage as
	select * 
	from depression_reg as a
	where a.id not in (
	select id
	from top_leverage(obs=15))
;
run;
quit;

* train new model;
proc reg data = depression_leverage;
model cat_total = income sex age /vif;
OUTPUT OUT=depression_reg  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit;
quit;
