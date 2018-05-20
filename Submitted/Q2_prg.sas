libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
* copy dataset from sasdata to work;
proc copy in=sasdata out=work;
	select Cereal_ds;
run;
* build a scatter plot to show the relationship between rating and sodium;
proc gplot data = Cereal_ds;
plot rating*sodium;
run;

*build a regression to predict rating by sodium;
proc reg data = Cereal_ds;
model rating = sodium;
OUTPUT OUT=cereal_reg  PREDICTED=   RESIDUAL=Res   L95M=C_l95m  U95M=C_u95m  L95=C_l95 U95=C_u95
       rstudent=C_rstudent h=lev cookd=Cookd  dffits=dffit;
quit;
