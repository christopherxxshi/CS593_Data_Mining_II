


/*PageRank Soluion*/
data Arcs;
    infile datalines;
    input Node $ A B C D  ;
    datalines;

A   0   1   1   0    
B   1   0   0   1    
C   1   0   0   1    
D   1   1   0   0    
;
run;

/*get the transition matrix*/
proc sql;
    create table matrix_1 as
        select a/sum(a) as x1
              ,b/sum(b) as x2
              ,c/sum(c) as x3
              ,d/sum(d) as x4                 
        from Arcs
    ;
quit;

/*Since there are 4 nodes, the initial vector v0 has 4 components, each 1/7*/
data rank_p;
    x1=1/4; 
    x2=1/4;
    x3=1/4;
    x4=1/4;
        output;
run;


proc iml;
    use matrix_1;
    read all var { x1 x2 x3 x4} into M;
    print M;

    use rank_p;
    read all var { x1 x2 x3 x4 } into rank_p1;
	print rank_p1;
    rank_p = t(rank_p1);
    print rank_p ; 
    
    rank_p2=M *rank_p;
    print rank_p2 ;     
   rank_p50=(M**50)*rank_p;
   print rank_p50 ;

quit;
