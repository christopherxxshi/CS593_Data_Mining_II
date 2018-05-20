proc copy in=sasdata out=work;
	select Spanish_bank_student;
run;

proc format;
	value GIfmt
		low - 200000 =A
		200000< - high =B
	;

data Spanish_bank_student2;
	set Spanish_bank_student(rename = (Gross_income = Gross_incomeb));
	Gross_income = input(Gross_incomeb,8.2);
	GI_cat = put(Gross_income, GIfmt.);
	nmod = mod(_n_, 11);
run;
