libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";

proc copy in=sasdata out=work;
	select Depression;
run;

title "Principal Component Analysis";
title2 "Univariate Analysis";

proc univariate data = Depression;
	var DRINK--CHRON_ILLNESS;
run;

title " ";
title2 " ";
proc standard DATA=Depression MEAN= 0 STD=1 out=Depression_z;
	var DRINK--CHRON_ILLNESS;
run;

title "Principal Component Analysis";
title2 "corrolation between variables";
proc corr data = Depression_z cov;
var DRINK--CHRON_ILLNESS;
run; 

title " ";
title2 " ";
proc princcomp data = Depression_z;
var DRINK--CHRON_ILLNESS;
run;

data Depression_z2;
  set Depression_z;
  	 compz_1=0.170216*DRINK + 0.458682*HEALTH - 0.124368*REG_DOC - 0.506643*TREATED + 0.376393*BEDDAYS + 0.255377*ACUTE_ILLNESS +0.530655*CHRON_ILLNESS; 
     compz_2=-0.287500*DRINK -0.27112*HEALTH + 0.342873*REG_DOC + 0.077589*TREATED +0.524437*BEDDAYS +0.637296*ACUTE_ILLNESS -0.1976751*CHRON_ILLNESS; 
     compz_3=0.674745*DRINK + 0.252348*HEALTH + 0.546949*REG_DOC + 0.328992*TREATED +0.221331*BEDDAYS -0.131388*ACUTE_ILLNESS -0.086024*CHRON_ILLNESS; 
	 compz_4=0.503666*DRINK - 0.128449*HEALTH - 0.698762*REG_DOC + 0.188895*TREATED +0.137397*BEDDAYS +0.323415*ACUTE_ILLNESS -0.287049*CHRON_ILLNESS; 
     compz_5=-0.420975*DRINK + 0.623922*HEALTH -0.240477*REG_DOC + 0.425175*TREATED +0.341233*BEDDAYS -0.191171*ACUTE_ILLNESS -0.204725*CHRON_ILLNESS; 
	 compz_6=-0.046741*DRINK - 0.048648*HEALTH -0.037496*REG_DOC + 0.637323*TREATED -0.221623*BEDDAYS +0.292046*ACUTE_ILLNESS +0.673390*CHRON_ILLNESS; 
     compz_7=-0.002461*DRINK + 0.494248*HEALTH + 0.142527*REG_DOC - 0.080132*TREATED -0.591500*BEDDAYS +0.533797*ACUTE_ILLNESS -0.306865*CHRON_ILLNESS; 
run;
title "Principal Component Analysis"; 
title2 " corrolation between components"; 
proc corr data=Depression_z2; 
var  compz_1--compz_7;
run;

** I find an efficient way to achieve PCA **;
proc princomp data=Depression            
               out=Depression_z_2          
               outstat=corstat      
               prefix=z;           
      var DRINK--CHRON_ILLNESS;  
run;  

