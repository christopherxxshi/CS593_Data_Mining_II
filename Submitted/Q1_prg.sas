libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";
* copy dataset from sasdata to work;
proc copy in=sasdata out=work;
	select baseball;
run;
* standardize numerical variables;
proc standard DATA=baseball MEAN= 0 STD=1 out=baseball_std;
	var age games-- triples RBIs--caught_stealing;
run;

*pca;
proc princomp data = baseball_std prefix = comp out = baseball_pca;
	var age games-- triples RBIs--caught_stealing;
run;
*test whether compontents are linearly independent or not;
proc corr data = baseball_pca out = baseball_comp_corr cov;
	var comp1--comp16;
run;
