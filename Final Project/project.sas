*save data as sasdata;
LIBNAME onpc "C:\Users\chrisshi\Desktop"; 
data onpc.wine;
set wine;
run;
/*
1 - fixed acidity
2 - volatile acidity
3 - citric acid
4 - residual sugar
5 - chlorides
6 - free sulfur dioxide
7 - total sulfur dioxide
8 - density
9 - pH
10 - sulphates
11 - alcohol
Output variable (based on sensory data):
12 - quality (score between 0 and 10)
*/
*load data;
libname sasdata "C:\vaersdata";
proc copy in=sasdata out=work;
	select wine;
run;


proc corr data=wine ;
var fixed_acidity--alcohol;
with quality;
run;

title "Normality assumption";
proc univariate data=wine normal;
var fixed_acidity--alcohol;
run;


proc reg data=wine ;
model quality = fixed_acidity--alcohol/ dwProb pcorr1 white VIF selection=stepwise;
run;


proc reg data=wine ;
model quality = fixed_acidity--total_sulfur_dioxide  pH--alcohol/ dwProb pcorr1 white VIF selection=stepwise;
run;


proc reg data=wine;
model quality = fixed_acidity volatile_acidity residual_sugar density chlorides free_sulfur_dioxide total_sulfur_dioxide pH sulphates alcohol ;
OUTPUT OUT=reg_out PREDICTED=predict RESIDUAL=residual L95M=L95m U95M=U95m L95=L95 U95=U95
rstudent=rstudent h=lev cookd=cookd dffits=dffits STDP=s_predicted STDR=s_residual STUDENT=student;
run;

title "univariate analysis for the reg output dataset";
proc univariate data=reg_out;
var lev cookd dffits;
run;


data wine_z;
set wine;
if _n_ = 2782 then delete;
run;

proc reg data=wine_z;
model quality = fixed_acidity--alcohol/ dwProb pcorr1 white VIF selection=stepwise;
run;

proc reg data=wine_z;
model quality = fixed_acidity volatile_acidity residual_sugar density chlorides free_sulfur_dioxide total_sulfur_dioxide pH sulphates alcohol ;
OUTPUT OUT=reg_z2_out PREDICTED=predict RESIDUAL=residual L95M=L95m U95M=U95m L95=L95 U95=U95
rstudent=rstudent h=lev cookd=cookd dffits=dffits STDP=s_predicted STDR=s_residual STUDENT=student;
run;

title "univariate analysis for the reg output dataset";
proc univariate data=reg_z2_out;
var lev cookd dffits;
run;

proc reg data=wine_z;
model quality = fixed_acidity--total_sulfur_dioxide  pH--alcohol/ dwProb pcorr1 white VIF selection=stepwise;
run;

