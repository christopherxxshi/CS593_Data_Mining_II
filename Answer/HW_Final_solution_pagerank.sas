
/****************************************************************** 
*   Developer: Khasha Dehnad
*   Purpose:   solution to HW4   
*                
*  
**********************************************************************/


data Arcs;
    infile datalines;
    input Node $ A B C D E F G;
    datalines;
A	0	1	1	0	0	1	0
B	1	0	0	1	0	0	1
C	0	0	0	1	0	1	0
D	1	1	0	0	1	0	0
E	0	0	1	0	0	0	0
F	0	0	0	0	1	0	0
G	0	1	0	0	0	0	0
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
    read all var { x1 x2 x3 x4 x5 x6 x7 } into M;
    print M;

    use rank_p;
    read all var { x1 x2 x3 x4 x5 x6 x7 } into rank_p1;
    rank_p = t(rank_p1);
    print rank_p ;   

   rank_p50=(M**50)*rank_p;
   print rank_p50 ;

quit;
