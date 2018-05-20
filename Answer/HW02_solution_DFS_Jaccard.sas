*-------------------------------------------------------------------------;
* Project        : HW 2                       ;
* Developer(s)   : Khasha Dehand                                          ;
* Comments       :                               ;
*                                                      ;
*-------------------------------------------------------------------------;

** copy the data from CANVAS 88;



%let prim=997;

proc format;
  value clstfmt 
     low   - 249  =A
     250  - 499   =B
     500  - 749   =C
     750 -  high  =D
  ;
run;


data sasdataA.Spanish_Bank_acct 
     sasdataB.Spanish_Bank_acct 
     sasdataC.Spanish_Bank_acct 
     sasdataD.Spanish_Bank_acct 
	 empty
	 ;
 set work.Spanish_Bank_student_acct    ;
 
 cluster =put(mod(Customer_code,997),clstfmt.);
  
        if cluster='A' then output sasdataA.Spanish_Bank_acct ;
   else if cluster='B' then output sasdataB.Spanish_Bank_acct ;
   else if cluster='C' then output sasdataC.Spanish_Bank_acct ;
   else if cluster='D' then output sasdataD.Spanish_Bank_acct ;
   else output empty;
run;
*-------------------------------------------------------------------------;
* calculate the  distance in the distributed file system         ;
*                                ;
*-------------------------------------------------------------------------;
option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskA wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataA";
 proc sql;
  create table Numerator   as 
     select count(*) as Numerator   from 
     sasdata.Spanish_Bank_acct  
	 where E_account=1 and  Payroll=1;
quit;
proc sql;
 create table denom as 
   select count(*) as denom 
   from   sasdata.Spanish_Bank_acct   
   where E_account=1 or  Payroll=1;

;
quit;

proc sql;
  create table sasdata.num_denom as
    select 'Num  ' as col1,Numerator  as col2
    from  Numerator
  union
    
    select 'Denom  ', Denom 
    from  denom;
quit;

endrsubmit;

   RDISPLAY;
  RGET taskA;

option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskB wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataB";
 proc sql;
  create table Numerator   as 
     select count(*) as Numerator   from 
     sasdata.Spanish_Bank_acct  
	 where E_account=1 and  Payroll=1;
quit;
proc sql;
 create table denom as 
   select count(*) as denom 
   from   sasdata.Spanish_Bank_acct   
   where E_account=1 or  Payroll=1;

;
quit;

proc sql;
  create table sasdata.num_denom as
    select 'Num  ' as col1,Numerator  as col2
    from  Numerator
  union
    
    select 'Denom  ', Denom 
    from  denom;
quit;

endrsubmit;

   RDISPLAY;
  RGET taskB;


option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskC wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataC";
 proc sql;
  create table Numerator   as 
     select count(*) as Numerator   from 
     sasdata.Spanish_Bank_acct  
	 where E_account=1 and  Payroll=1;
quit;
proc sql;
 create table denom as 
   select count(*) as denom 
   from   sasdata.Spanish_Bank_acct   
   where E_account=1 or  Payroll=1;

;
quit;

proc sql;
  create table sasdata.num_denom as
    select 'Num  ' as col1,Numerator  as col2
    from  Numerator
  union
    
    select 'Denom  ', Denom 
    from  denom;
quit;

endrsubmit;

   RDISPLAY;
  RGET taskC;

option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskD wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataD";
 proc sql;
  create table Numerator   as 
     select count(*) as Numerator   from 
     sasdata.Spanish_Bank_acct  
	 where E_account=1 and  Payroll=1;
quit;
proc sql;
 create table denom as 
   select count(*) as denom 
   from   sasdata.Spanish_Bank_acct   
   where E_account=1 or  Payroll=1;

;
quit;

proc sql;
  create table sasdata.num_denom as
    select 'Num  ' as col1,Numerator  as col2
    from  Numerator
  union
    
    select 'Denom  ', Denom 
    from  denom;
quit;

endrsubmit;

   RDISPLAY;
  RGET taskD;





LISTTASK _ALL_;
 
waitfor _all_ taskA taskB taskC taskD;
*%put &pathtask1;
*%put &pathtask2;
libname sasdataA slibref=sasdata server=taskA;
libname sasdataB slibref=sasdata server=taskB;
libname sasdataC slibref=sasdata server=taskC;
libname sasdataD slibref=sasdata server=taskD;
data  num_denom_all;
  set   sasdataA.num_denom
        sasdataB.num_denom
        sasdataC.num_denom
        sasdataD.num_denom
; 
run; 
proc sql;
  create table Jacc_dist as
  select a.num/b.Denom as Jacc_dist from
    (select sum(col2)as Num 
    from num_denom_all
    where col1='Num') A,

    (select sum(col2) as Denom
    from num_denom_all
    where col1='Denom') B
	;
quit;
    

signoff taskA;
signoff taskB;

signoff _all_;
