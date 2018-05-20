libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
libname sasdataA "c:\Users\chrisshi\Desktop\SAS_dataA";
libname sasdataB "c:\Users\chrisshi\Desktop\SAS_dataB";
libname sasdataC "c:\Users\chrisshi\Desktop\SAS_dataC";
libname sasdataD "c:\Users\chrisshi\Desktop\SAS_dataD";

proc copy in=sasdata out=work;
	select Spanish_bank_student_acct;
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

data sasdataA.Spanish_bank_student_acct
	 sasdataB.Spanish_bank_student_acct
	 sasdataC.Spanish_bank_student_acct
	 sasdataD.Spanish_bank_student_acct
	 empty
	 ;
set sasdata.Spanish_bank_student_acct;
cluster = put(mod(Customer_code, 997), clstfmt.);

	 if cluster = 'A' then output sasdataA.Spanish_bank_student_acct ;
else if cluster = 'B' then output sasdataB.Spanish_bank_student_acct ;
else if cluster = 'C' then output sasdataC.Spanish_bank_student_acct ;
else if cluster = 'D' then output sasdataD.Spanish_bank_student_acct ;
else output empty;

run;

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
		create table E_P_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Payroll = 1;
	quit;
	proc sql;
		create table E_P_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Payroll = 1;
	quit;
	proc sql;
		create table E_D_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Direct_Debit = 1;
	quit;
	proc sql;
		create table E_D_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Direct_Debit = 1;
	quit;
endrsubmit;

rsubmit taskB wait=no sysrputsync = yes;
	proc sql;
		create table E_P_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Payroll = 1;
	quit;
	proc sql;
		create table E_P_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Payroll = 1;
	quit;
	proc sql;
		create table E_D_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Direct_Debit = 1;
	quit;
	proc sql;
		create table E_D_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Direct_Debit = 1;
	quit;
endrsubmit;

rsubmit taskC wait=no sysrputsync = yes;
	proc sql;
		create table E_P_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Payroll = 1;
	quit;
	proc sql;
		create table E_P_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Payroll = 1;
	quit;
	proc sql;
		create table E_D_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Direct_Debit = 1;
	quit;
	proc sql;
		create table E_D_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Direct_Debit = 1;
	quit;
endrsubmit;

rsubmit taskD wait=no sysrputsync = yes;
	proc sql;
		create table E_P_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Payroll = 1;
	quit;
	proc sql;
		create table E_P_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Payroll = 1;
	quit;
	proc sql;
		create table E_D_numerator as
			select count(*) as numerator
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 and Direct_Debit = 1;
	quit;
	proc sql;
		create table E_D_denom as
			select count(*) as denom
			from sasdata.Spanish_bank_student_acct
			where E_account = 1 or Direct_Debit = 1;
	quit;
endrsubmit;

listtask _all_;
waitfor _all_ taskA taskB taskC taskD;
*%put &pathtask1;
*%put &pathtask2;
libname rworkA slibref = work server = taskA;
libname rworkB slibref = work server = taskB;
libname rworkC slibref = work server = taskC;
libname rworkD slibref = work server = taskD;

data bothE_P_numerator;
	set rworkA.E_P_numerator rworkB.E_P_numerator rworkC.E_P_numerator rworkD.E_P_numerator;
run;
data bothE_P_denom;
	set rworkA.E_P_denom rworkB.E_P_denom rworkC.E_P_denom rworkD.E_P_denom;
run;
data bothE_D_numerator;
	set rworkA.E_D_numerator rworkB.E_D_numerator rworkC.E_D_numerator rworkD.E_D_numerator;
run;
data bothE_D_denom;
	set rworkA.E_D_denom rworkB.E_D_denom rworkC.E_D_denom rworkD.E_D_denom;
run;
signoff _all_;

proc sql;
 create table similar as
 	select sum(a.numerator)/sum(b.denom) as E_P_similar, sum(c.numerator)/sum(d.denom) as E_D_similar 
	from bothE_P_numerator a, bothE_P_denom b, bothE_D_numerator c, bothE_D_denom d;
quit;
