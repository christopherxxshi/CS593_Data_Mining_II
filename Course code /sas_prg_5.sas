***Task A***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskA wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataA";
*%sysrput pathtaskA = %sysfunc(pathname(work));
endrsubmit;

RDISPLAY;

***Task B***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskB wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataB";
%sysrput pathtaskB = %sysfunc(pathname(work));
endrsubmit;

RDISPLAY;

***Task C***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskC wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataC";
*%sysrput pathtaskC = %sysfunc(pathname(work));
endrsubmit;

RDISPLAY;

***Task D***;
option autosignon = yes;
option sascmd = "!sascmd";
rsubmit taskD wait=no sysrputsync = yes;
libname sasdata "C:\Users\chrisshi\Desktop\SAS_dataD";
*%sysrput pathtaskD = %sysfunc(pathname(work));
endrsubmit;

RDISPLAY;

rsubmit taskA wait=no sysrputsync = yes;
	proc sql;
		create table max_income as
			select max(Gross_income) as max_income from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;

rsubmit taskB wait=no sysrputsync = yes;
	proc sql;
		create table max_income as
			select max(Gross_income) as max_income from 
			sasdata.Spanish_bank;
	quit;
endrsubmit;

endrsubmit;

listtask _all_;
waitfor _all_ taskA taskB;
*%put &pathtask1;
*%put &pathtask2;
libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;

data bothAB;
	set rworkA.max_income rworkB.max_income;
run;








*signoff _all_;

