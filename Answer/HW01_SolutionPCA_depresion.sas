*-------------------------------------------------------------------------;
* Project        : HW 1                       ;
* Developer(s)   : Khasha Dehand                                          ;
* Comments       :                               ;
*                                                      ;
*-------------------------------------------------------------------------;



title "Principal Component Analysis"; 
title2 " Univariate Analysis"; 
proc univariate data= depression ;
   var  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS CHRON_ILLNESS;
run;
title " "; 
title2 " "; 

proc corr data=depression cov;
  var  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS
            CHRON_ILLNESS; 
run;

*** Normalize the data ***;
PROC STANDARD DATA=depression
             MEAN=0 STD=1 
             OUT=depression_z;
  VAR  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS
            CHRON_ILLNESS;
RUN;


proc princomp   data=depression_z  out=depression_pca;
 VAR  DRINK HEALTH REG_DOC TREATED BEDDAYS ACUTE_ILLNESS
            CHRON_ILLNESS;
run;

proc corr data=depression_pca   ;
  var Prin1-Prin7 ; 
run;



