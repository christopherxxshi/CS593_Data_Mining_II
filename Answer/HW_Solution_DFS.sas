*-------------------------------------------------------------------------;
* Project        :  HW1                                       ;
* Developer(s)   :  Khasha Dehand                                         ;
* Comments       :  HW_1 Solution                 ;
*-------------------------------------------------------------------------;

** import data  using SAS interface
** name: income_by_zip;

%let prim=997;

proc format;
  value clstfmt 
     low   - 249  =A
     250  - 499   =B
     500  - 749   =C
     750 -  high  =D
  ;
run;


data sasdataA.income_by_zip 
     sasdataB.income_by_zip 
     sasdataC.income_by_zip 
     sasdataD.income_by_zip 
	 empty
	 ;
 set work.income_by_zip 
      ;

 cluster =put(mod(zipcode,997),clstfmt.);
  
        if cluster='A' then output sasdataA.income_by_zip;
   else if cluster='B' then output sasdataB.income_by_zip  ;
   else if cluster='C' then output sasdataC.income_by_zip  ;
   else if cluster='D' then output sasdataD.income_by_zip  ;
   else output empty;
run;
