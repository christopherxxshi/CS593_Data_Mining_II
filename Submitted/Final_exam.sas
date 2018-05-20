libname sasdata "c:\Users\chrisshi\Desktop\SAS_Data";

proc copy in=sasdata out=work;
	select lung Breast_cancer_data Heart_attack;
run;
*p#3.1;
proc reg data = lung;
foreward: model Height_oldest_child = Age_oldest_child Weight_oldest_child 
			Height_mother Weight_mother Height_father Weight_father/ selection= foreward;
backward: model Height_oldest_child = Age_oldest_child Weight_oldest_child 
			Height_mother Weight_mother Height_father Weight_father/ selection= backward;
stepwise: model Height_oldest_child = Age_oldest_child Weight_oldest_child 
			Height_mother Weight_mother Height_father Weight_father/ selection= stepwise;
run;
*p#3.2;
proc reg data = lung;
foreward: model Height_oldest_child = Age_oldest_child Weight_oldest_child 
			Height_mother Weight_mother Height_father Weight_father/ selection= MAXR;
run;


*p#4;
proc logistic data=heart_attack descending;
class Anger_Treatment(ref='0')/param = ref;
model Heart_Attack_2 = Anxiety_Treatment Anger_Treatment;
quit;

data heart_2;
set heart_attack;
	if Anxiety_Treatment < 60 then V_AT = 0;
	else V_AT = 1;
run;

proc logistic data=heart_2 descending;
class V_AT(ref='0') Anger_Treatment(ref='0')/param = ref;
model Heart_Attack_2 = V_AT;
quit;

*p#5;
*** Normalize the data ***;
PROC STANDARD DATA=Breast_cancer_data
             MEAN=0 STD=1 
             OUT=Breast_cancer_data_z;
  VAR   radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
		compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean;
RUN;

proc princomp   data=Breast_cancer_data_z  out=Breast_cancer_data_pca;
 VAR  radius_mean texture_mean perimeter_mean area_mean smoothness_mean 
		compactness_mean concavity_mean concave_points_mean symmetry_mean fractal_dimension_mean;
run;


*p#6;
data Arcs;
    infile datalines;
    input Node $ A B C D E F G ;
    datalines;

A   0   1   1	0	0	1	0
B   1   0   0   1	0	0	1
C   0   0   0   1	0	1	0
D   1   1   0   0	1	0	0
E   0   0   1   0	0	0	0
F   0   0   0   0	1	0	0
G   0   1   0   0	0	0	0
;
run;
/*get the transition matrix*/
proc sql;
    create table matrix_1 as
        select a/sum(a) as x1
              ,b/sum(b) as x2
              ,c/sum(c) as x3
              ,d/sum(d) as x4
			  ,e/sum(e) as x5
			  ,f/sum(f) as x6
			  ,g/sum(g) as x7
        from Arcs
    ;
quit;

/*Since there are 7 nodes, the initial vector v0 has 7 components, each 1/7*/
data rank_p;
    x1=1/7; 
    x2=1/7;
    x3=1/7;
    x4=1/7;
	x5=1/7;
	x6=1/7;
	x7=1/7;
    output;
run;

proc iml;
use matrix_1;
read all var {x1 x2 x3 x4 x5 x6 x7} into M;
print M;
use rank_p;
read all var {x1 x2 x3 x4 x5 x6 x7} into rank_p1;
print rank_p1;
rank_p = t(rank_p1);
print rank_p;

rank_p2 = M*rank_p;
print rank_p2;
rank_p50 = (M**50)*rank_p;
print rank_p50;
quit;
