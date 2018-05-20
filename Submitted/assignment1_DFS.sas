libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
libname sasdata1 "c:\Users\chrisshi\Desktop\sasdata1";
libname sasdata2 "c:\Users\chrisshi\Desktop\sasdata2";
libname sasdata3 "c:\Users\chrisshi\Desktop\sasdata3";
libname sasdata4 "c:\Users\chrisshi\Desktop\sasdata4";

proc copy in=sasdata out=work;
	select Income_by_zip_code;
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

data sasdata1.Income
	 sasdata2.Income
	 sasdata3.Income
	 sasdata4.Income
	 empty
	 ;
set sasdata.Income_by_zip_code;
cluster = put(mod(zip_code, 997), clstfmt.);

	 if cluster = 'A' then output sasdata1.Income ;
else if cluster = 'B' then output sasdata2.Income ;
else if cluster = 'C' then output sasdata3.Income ;
else if cluster = 'D' then output sasdata4.Income ;
else output empty;

run;
	
