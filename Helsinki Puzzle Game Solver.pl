grid_build(N,M):-
				length(M,N),
				length1(N,M).

length1(_,[]).				
length1(N,[H|T]):-
				length(H,N),
				length1(N,T).

grid_gen(N,M):-
			grid_build(N,M),
			num_gen(1,N,S),
			put(M,S).
			
put([],_).
put([H|T],S):-
					puthelper(H,S),
					put(T,S).

puthelper([],_).
puthelper([H|T],S):-
					member(H,S),
					puthelper(T,S).

num_gen(F,L,[]):-
					F>L.
num_gen(F,L,[F|R]):-
					F=<L,
					F1 is F+1,
					num_gen(F1,L,R).
					
check_num_grid(G):-
					length(G,N),
					maxRec(G,M),
					N>=M,
					M1 is M-1,
					find(G,G,M1).
					
find(_,_,0).				
find([H|_],S,M):-
			M\=0,
			is_member(M,H),
			M1 is M-1,
			find(S,S,M1).
find([H|T],S,M):-
			M\=0,
			\+is_member(M,H),
			find(T,S,M).
			
			
is_member(X,[X|_]).
is_member(X,[H|T]):-
					X\=H,
					is_member(X,T).
				
maxRec(L,M):-
				maxRec(L,M,[]).
maxRec([],M,A):-
				maxList(A,M).
maxRec([H|T],M,A):-
					maxList(H,M1),
					A1 = [M1|A],
					maxRec(T,M,A1).
				
maxList([],R,R). 
maxList([H|T],X,R):- 
						H>X, 
						maxList(T,H,R).
maxList([H|T],X,R):- 
					H=<X, 
					maxList(T,X,R).
maxList([H|T],R):- 
					maxList(T,H,R).			
				

acceptable_permutation(L,Z):-
					permutation(L,Z),
					check(L,Z).
					
check([],[]).					
check([H|T],[H1|T1]):-
						H\=H1,
						check(T,T1).
						
trans([],[]).
trans([[H|T]|T1],[[H|N1]|N2]) :- 
									trans_helper(T1,N1,R),
									trans(R,NR), 
									trans_helper(N2,T,NR).
trans_helper([],[],[]).
trans_helper([[H|T]|T1],[H|C],[T|R]) :- 
									trans_helper(T1,C,R).
									
acceptable_distribution(M):-
							trans(M,N),
							check(M,N).

row_col_match(M):-
					trans(M,N),
					check1(M,N,0,0,N).
check1([],_,_,_,_).					
check1([H|T],[_|T1],I,J,N):-
				I=J,
				J1 is J+1,
				check1([H|T],T1,I,J1,N).

check1([H|T],[H1|_],I,J,N):-
				I\=J,
				H = H1,
				I1 is I+1,
				check1(T,N,I1,0,N).

check1([H|T],[H1|T1],I,J,N):-
				I\=J,
				H \= H1,
				J1 is J+1,
				check1([H|T],T1,I,J1,N).	

distinct_rows([]).
distinct_rows([H|T]):-
						\+member(H,T),
						distinct_rows(T).
				
				
distinct_columns(M):-
					trans(M,N),
					distinct1(N).		
distinct1([]).		
distinct1([H|T]):-
				\+member(H,T),
				distinct1(T).
				
helsinki(N,G):-
				grid_gen(N,G),
				row_col_match(G),
				check_num_grid(G),
				acceptable_distribution(G),
				distinct_rows(G),
				distinct_columns(G).
			
				
						
			