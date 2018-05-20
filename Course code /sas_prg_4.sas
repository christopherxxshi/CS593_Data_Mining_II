proc copy in= sashelp out = work;
	select iris;
run;

title "Principal Component Analysis";
title2 "Univariate Analysis";

proc univariate data = iris;
	var PetalWidth PetalLength;
run;

title " ";
title2 " ";
proc standard DATA=iris MEAN= 0 STD=1 out=iris_z(rename=(PetalWidth = PetalWidth_z PetalLength = PetalLength_z));
	var PetalWidth PetalLength;
run;

*proc standard data=iris(keep = SepalLength);

title "Principal Component Analysis";
title2 "corrolation between variables";
proc corr data = iris_z cov;
var PetalWidth_z PetalLength_z;
run; 


title "Principal Component Analysis";
title2 "Plot of the normalized data";
proc sgplot data = iris_z;
	scatter x = PetalWidth_z y = PetalLength_z;
	ellipse x = PetalWidth_z y = PetalLength_z;
run;

title " ";
title2 " ";
proc princcomp data = iris_z;
var PetalWidth_z PetalLength_z;
run;

data iris_z2;
	set iris_z;
	compz_1 = 0.707107*PetalWidth_z + 0.707107*PetalLength_z;
	compz_2 = 0.707107*PetalWidth_z - 0.707107*PetalLength_z;
run;

title "Principal Component Analysis";
title2 "corrolation between components";
proc corr data = iris_z2;
var compz_1 compz_2;
run;

title "Principal Component Analysis";
title2 "plot of normalizied data";
proc sgplot data = iris_z2;
