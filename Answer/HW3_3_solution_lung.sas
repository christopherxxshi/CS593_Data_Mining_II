*-------------------------------------------------------------------------;
* Project        :                            ;
* Developer(s)   : Khasha Dehand                                          ;
* Comments       : Soluition to homework #3.3                               ;
*                                                    ;
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




* copy the datasets in to the work library *;

proc copy in=sas_data out=work;
   select lung ;
run;
/*
selection=forward
selection=backward
selection=stepwise
selection=MAXR
*/

title  " Multiple Regression for Lung dataset";
title2 " Height_oldest_child vs. age weight of the oldest child and weight and height of parents ";

proc reg data=lung  outest=LungEst_ ;
     model    Height_oldest_child    =  Age_oldest_child Weight_oldest_child
                                        Height_mother     Weight_mother
                                        Height_father     Weight_father
                                 /   dwProb STB selection=MAXR ; 
 quit; 
title  " Multiple Regression for Lung dataset";
title2 " Height_oldest_child vs. age weight of the oldest child and weight and height of parents ";

proc reg data=lung  outest=LungEst_ ;
     model    Height_oldest_child    =  Age_oldest_child Weight_oldest_child
                                        Height_mother    
                                        Height_father     
                                 /   dwProb STB; 
 quit;

