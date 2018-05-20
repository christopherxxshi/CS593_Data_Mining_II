*-------------------------------------------------------------------------;
* Project        :  BIA652  Mulivariate Analysis                          ;
* Developer(s)   : Khasha Dehand                                          ;
* Comments       : Soluition to homework #3                               ;
*                  problem 7.5 of Afifi                                   ;
*-------------------------------------------------------------------------;
/*
COOKD= Cook’s  influence statistic
COVRATIO=standard influence of observation on covariance of betas
DFFITS=standard influence of observation on predicted value
H=leverage, 
LCL=lower bound of a % confidence interval for an individual prediction. This includes the variance of the error, as well as the variance of the parameter estimates.
LCLM=lower bound of a % confidence interval for the expected value (mean) of the dependent variable
PREDICTED | P= predicted values
RESIDUAL | R= residuals, calculated as ACTUAL minus PREDICTED
RSTUDENT=a studentized residual with the current observation deleted
STDI=standard error of the individual predicted value
STDP= standard error of the mean predicted value
STDR=standard error of the residual
STUDENT=studentized residuals, which are the residuals divided by their standard errors
UCL= upper bound of a % confidence interval for an individual prediction
UCLM= upper bound of a % confidence interval for the expected value (mean) of the dependent variable
* Cook’s  statistic lies above the horizontal reference line at value 4/n *; 
* DFFITS’ statistic is greater in magnitude than 2sqrt(n/p);
* Durbin watson around 2 *;
* VIF over 10 multicolinear **;


*/

****************************************************** 

Everyone gets full credit for this question (cat_total)
did not exist in the supplied dataset

*********************************************************;



proc copy in=sas_data out=work;
   select depression ;
run;



proc univariate data=depression normaltest;* plot;
   var Cat_total income age sex  ;  
   
run;


title " Multiple Regression Cat_total vs. income sex age : Depression dataset ";
proc reg data=depression  outest=DepEst_cat  ;
     model    Cat_total =  income sex age  / VIF  dwProb STB   ;
      OUTPUT OUT=regout_Dep_cat  PREDICTED=predict   RESIDUAL=Res 
                      L95M=l95m  U95M=u95m  L95=l95 U95=u95
       rstudent=rstudent h=lev cookd=Cookd  dffits=dffit
     STDP=s_predicted  STDR=s_residual  STUDENT=student     ;  
     
  quit;

title " Univariate analysis of residuals and rstudent ";
proc univariate data=regout_Dep_cat normaltest;* plot;
   var Res  rstudent  ;  
   
run;
