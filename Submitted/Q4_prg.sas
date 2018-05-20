libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
libname sasdataA "c:\Users\chrisshi\Desktop\SAS_dataA";
libname sasdataB "c:\Users\chrisshi\Desktop\SAS_dataB";
libname sasdataC "c:\Users\chrisshi\Desktop\SAS_dataC";
libname sasdataD "c:\Users\chrisshi\Desktop\SAS_dataD";
* copy dataset from sasdata to work;
proc copy in=sasdata out=work;
	select Spanish_bank_student;
run;

%let prim = 997;

proc format;
	value clstfmt
		low - 249 = A
		250 - 499 = B
		500 - 749 = C
		750 - high = D
		;
run;
* distribute data ;
data sasdataA.Spanish_Bank
	 sasdataB.Spanish_Bank
	 sasdataC.Spanish_Bank
	 sasdataD.Spanish_Bank
	 empty
	 ;
set sasdata.Spanish_Bank_student;
cluster = put(mod(Customer_code, 997), clstfmt.);
	 if cluster = 'A' then output sasdataA.Spanish_Bank ;
else if cluster = 'B' then output sasdataB.Spanish_Bank ;
else if cluster = 'C' then output sasdataC.Spanish_Bank ;
else if cluster = 'D' then output sasdataD.Spanish_Bank ;
else output empty;
run;
*create tasks;
***Task A***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataA";
endrsubmit;

RDISPLAY;

***Task B***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataB";
endrsubmit;

RDISPLAY;

***Task C***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskC wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataC";
endrsubmit;

RDISPLAY;

***Task D***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskD wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataD";
endrsubmit;

RDISPLAY;

*calculate sum of age and number of customer on every task;
rsubmit taskA wait=no sysrputsync = yes;
	proc sql;
		create table average_age as
			select sum(age)as total_age ,count(*) as counter from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;

rsubmit taskB wait=no sysrputsync = yes;
	proc sql;
		create table average_age as
			select sum(age)as total_age ,count(*) as counter from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;

rsubmit taskC wait=no sysrputsync = yes;
	proc sql;
		create table average_age as
			select sum(age)as total_age ,count(*) as counter from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;

rsubmit taskD wait=no sysrputsync = yes;
	proc sql;
		create table average_age as
			select sum(age)as total_age ,count(*) as counter from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;
endrsubmit;
listtask taskA taskB taskC taskD;
waitfor taskA taskB taskC taskD;
* get the data from four taskes;
libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;
libname rworkC slibref = work server = taskC;
libname rworkD slibref = work server = taskD;
data average_age_info;
	set rworkA.average_age rworkB.average_age rworkC.average_age rworkD.average_age;
run;
*calculate average age;
proc sql;
create table average_age as
	select sum(total_age)/sum(counter) as average_age
	from average_age_info;
quit;

signoff _all_;
