
*-------------------------------------------------------------------------;
* Project        :  SQL in Map Reduce                                         ;
* Developer(s)   :  Khasha Dehand                                         ;
* Comments                     ;
*        Using distributed SQL, calculate the average “Age”;
*        of the “Spanish Bank” customers. 
*-------------------------------------------------------------------------;
option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskA wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataA";
 proc sql;
     create table sum_age as
	   select sum(age) as  total_age
	          ,count(age) as cnt_age
        from
       sasdata.spanish_bank   ;
 quit;


endrsubmit;

   *RDISPLAY;
  RGET taskA;

option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskB wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataB";
 proc sql;
     create table sum_age as
	   select  sum(age) as total_age
	          ,count(age) as cnt_age
			 
        from
       sasdata.spanish_bank
  ;
 quit;

endrsubmit;

   *RDISPLAY;
  RGET taskB;


option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskC wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataC";
 proc sql;
     create table sum_age as
	   select  sum(age) as total_age
	          ,count(age) as cnt_age
        from
       sasdata.spanish_bank
  ;
 quit;

endrsubmit;

   *RDISPLAY;
  RGET taskC;

option autosignon=yes;
option sascmd="!sascmd"; 
rsubmit taskD wait=no  sysrputsync=yes;
 libname sasdata "C:\AIMS\Stevens_\2018_CS593\SAS_dataD";
 proc sql;
     create table sum_age as
	   select  sum(age) as total_age
	          ,count(age) as cnt_age
        from
       sasdata.spanish_bank
  ;
 quit;

endrsubmit;

   *RDISPLAY;
  RGET taskD;





LISTTASK _ALL_;
 
waitfor _all_ taskA taskB taskC taskD;
*%put &pathtask1;
*%put &pathtask2;
libname sasdataA slibref=work server=taskA;
libname sasdataB slibref=work server=taskB;
libname sasdataC slibref=work server=taskC;
libname sasdataD slibref=work server=taskD;
data  sum_age_all;
  set   sasdataA.sum_age
        sasdataB.sum_age
        sasdataC.sum_age
        sasdataD.sum_age
; 
run;
quit; 
proc sql;
  create table age_avg  as
  select sum(total_age) /sum(cnt_age)  as age_avg from
    sum_age_all
	;
quit;
    



signoff _all_;




 
