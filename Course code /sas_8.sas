libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
proc copy in=sasdata out=work;
	select churn;
run;

data churn2;
set churn;
if churn ='False.' then V_churn = 0;
else V_churn = 1;
if VMail_Plan='yes' then V_voiceplan = 1;
else V_voiceplan = 0;
run;

proc freq data = churn2;
table V_churn*V_voiceplan;
run;

proc logistic data = churn2 descending;
	class V_voiceplan(ref='0')/param = ref;
	model V_churn = V_voiceplan;
quit;

data churn3;
	set churn;
	
	if churn ='False.' then V_churn = 0;
	else V_churn = 1;
	if VMail_Plan='yes' then V_voiceplan = 1;
	else V_voiceplan = 0;
	
	if CustServ_Calls < 2 then V_CSC = 0;
	else if CustServ_Calls < 4 then V_CSC = 1;
	else V_CSC = 2;

	if CustServ_Calls < 4 and CustServ_Calls > 1  then V_CSCtemp1=1;
	else V_CSCtemp1=0;
	if CustServ_Calls >= 4 then V_CSCtemp2=1;
	else V_CSCtemp2=0;
	
	if CustServ_Calls < 4 then V_CSC2 = 0;
	else V_CSC2 = 1;
run;

proc logistic data = churn3 descending;
	class V_voiceplan(ref='0')/param = ref;
	model V_churn = V_voiceplan;
quit;
proc logistic data = churn3 descending;
	class V_CSCtemp1(ref='0') V_CSCtemp2(ref='0')/param = ref;
	model V_churn = V_CSCtemp1 V_CSCtemp2 ;
quit;
proc logistic data = churn3 descending;
	class V_CSC(ref='0')/param = ref;
	model V_churn = V_CSC;
quit;

proc logistic data = churn3 descending;
	class V_CSC2(ref='0')/param = ref;
	model V_churn = V_CSC2;
quit;

data churn3;
	set churn;
	
	if churn ='False.' then V_churn = 0;
	else V_churn = 1;
	if VMail_Plan='yes' then V_voiceplan = 1;
	else V_voiceplan = 0;
	if CustServ_Calls < 2 then V_CSC = 0;
	else if CustServ_Calls < 4 then V_CSC = 1;
	else V_CSC = 2;

	if CustServ_Calls < 4 and CustServ_Calls > 1  then V_CSCtemp1=1;
	else V_CSCtemp1=0;
	if CustServ_Calls >= 4 then V_CSCtemp2=1;
	else V_CSCtemp2=0;
	if CustServ_Calls < 4 then V_CSC2 = 0;
	else V_CSC2 = 1;
	if Int_l_Plan = 'no' then V_int=0;
	else V_int=1;
run;
proc logistic data = churn3 descending;
	class V_CSC2(ref='0')/param = ref;
	model V_churn = V_CSC2;
quit;

proc logistic data=churn3 descending;
	model V_churn = Day_Mins;
quit;


proc logistic data=churn3 descending;
class V_int(ref='0') V_voiceplan(ref='0') V_CSC2(ref='0');
model V_churn = V_int V_voiceplan V_CSC2  
Day_Mins Eve_Mins Night_Mins Intl_Mins;
quit;
