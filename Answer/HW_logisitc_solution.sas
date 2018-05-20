
data depression_v2;
  set depression;
  if Cat_total>=16 then depressed=1;
  else depressed=0;
run;
data depression_v3;
   set depression_v2;
   ln_income=log(income);
   
run;

proc freq data=depression_v3;
  table health ;
run; 
proc logistic data=depression_v3  descending   ;
  class health (ref='1')  ;
  model   depressed=age sex ln_income  health     ;  
quit;

proc logistic data=depression_v3  descending   ;
  class health (ref='1')  ;
  model   depressed=age sex   ln_income  health/noint ;  
quit;

data depression_v4;
   set depression_v3;
   if health<3 then dummy=0;
   else dummy=1;
   
run;

proc logistic data=depression_v4  descending   ;
  class  dummy (ref='0')  ;
  model   depressed=age sex   ln_income  dummy/noint ;  
quit;

