% 2 new elements in predicate across. across(X,Y,R1,R2,L). R1: number of missionaries can row. R2: number of cannibals can row.
% Command: clingo 0 -c length=13 a5_q2_9.lp

% Defining the constants
time(0..length).  
number(0..2). 
rower(0;1).
location(l1).           location(l2).       % two banks 

% X missionaries and Y cannibals are at location L, R1 missionalries can row, R2 cannibals can row.
fluent(at(X,Y,R1,R2,L)):-      number(X),number(Y),rower(R1),rower(R2),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% I+R1 missionaries and J+R2 cannibals move from one bank to another
action(cross(I,J,R1,R2,L)):- 
   number(I), number(J),rower(R1),rower(R2), location(L), I+J+R1+R2 <= 2, I+J+R1+R2 > 0, R1+R2>=1.

holds(at(M+P,N+Q,R1+V1,R2+V2,L1),T+1):-  time(T), 
   number(M), number(N), location(L), 
   number(P), number(Q), action(cross(M,N,V1,V2,L)), 
   occ(cross(M,N,V1,V2,L), T), location(L1),   L!=L1,
   rower(R1), rower(R2),rower(V1),rower(V2), 
   holds(at(P,Q,R1,R2,L1), T).

holds(at(P-M,Q-N,R1-V1,R2-V2,L),T+1):-
     time(T),
     number(M), number(N), location(L), 
     number(P), number(Q), action(cross(M,N,V1,V2,L)), 
     occ(cross(M,N,V1,V2,L), T), 
     holds(at(P,Q,R1,R2,L), T),rower(R1),rower(R2), rower(V1), rower(V2).

holds(boat_at(L1),T+1):-
     time(T),
     number(M), number(N), location(L),
     rower(R1),rower(R2), 
     action(cross(M,N,R1,R2,L)), location(L1), L!=L1,
     occ(cross(M,N,R1,R2,L), T).

 
% executability condition
executable(cross(I,J,V1,V2,L), T):-
     time(T),
     number(I), number(J), location(L), 
     number(P), number(Q), action(cross(I,J,V1,V2,L)), 
     holds(boat_at(L), T),
     holds(at(P, Q, R1, R2, L), T), P+R1>=I+V1, Q+R2>=J+V2,
     rower(R1),rower(R2),rower(V1), rower(V2).

% initial condition
holds(at(2,2,1,1,l1),0). 
holds(at(0,0,0,0,l2),0). 
holds(boat_at(l1),0). 

% constraint
% bad(1,T):-  

:- time(T), action(cross(I,J,R1,R2,L)), occ(cross(I,J,R1,R2,L), T), not executable(cross(I,J,R1,R2,L), T).

%bad(2,T)

:- number(I), number(J), location(L),rower(R1),rower(R2), 
     time(T), holds(at(I,J,R1,R2,L), T), I+R1 < J+R2, I+R1 > 0.

% goal
:- not goal(length).

goal(T):- holds(at(2,2,1,1,l2), T). 

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T). 

#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
