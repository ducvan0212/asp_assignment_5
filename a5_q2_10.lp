% Solution: the big cannibal is separated into a group.
% Command: clingo 0 -c length=15 a5_q2_10.lp

% Defining the constants
time(0..length).  
number(0..3). 
big(0;1).
location(l1).           location(l2).       % two banks 

% X missionaries and Y cannibals are at location L, B is the big cannibal.
fluent(at(X,Y,B,L)):-      number(X),number(Y),big(B),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% I missionaries and J cannibals move from one bank to another. If the BIG (B) cannibal crosses the river, noone can be in the boat exept him.
action(cross(I,J,B,L)):- 
   number(I), number(J),big(B), location(L), 
   I+J <= 2, I+J >= 0, B*(I+J) == 0, B+I+J != 0.

holds(at(M+P,N+Q,R1+V1,L1),T+1):-  time(T), 
   number(M), number(N), location(L), 
   number(P), number(Q), action(cross(M,N,V1,L)), 
   occ(cross(M,N,V1,L), T), location(L1),   L!=L1,
   big(V1), big(R1), 
   holds(at(P,Q,R1,L1), T).

holds(at(P-M,Q-N,B-V,L),T+1):-
     time(T),
     number(M), number(N), location(L), 
     number(P), number(Q), big(B), big(V),
     action(cross(M,N,V,L)), 
     occ(cross(M,N,V,L), T), 
     holds(at(P,Q,B,L), T).

holds(boat_at(L1),T+1):-
     time(T),
     number(M), number(N), location(L),
     big(R1), 
     action(cross(M,N,R1,L)), location(L1), L!=L1,
     occ(cross(M,N,R1,L), T).

 
% executability condition
executable(cross(I,J,B1,L), T):-
     time(T),
     number(I), number(J), location(L), 
     number(P), number(Q), action(cross(I,J,B1,L)), 
     holds(boat_at(L), T),
     holds(at(P, Q, B2, L), T), P>=I, Q>=J, B2 >= B1,
     big(B1), big(B2).

% initial condition
holds(at(3,2,1,l1),0). 
holds(at(0,0,0,l2),0). 
holds(boat_at(l1),0). 

% constraint
% bad(1,T):-  
:- time(T), action(cross(I,J,R1,L)), occ(cross(I,J,R1,L), T), not executable(cross(I,J,R1,L), T).


%bad(2,T)
:- number(I), number(J), location(L),big(B), 
     time(T), holds(at(I,J,B,L), T), I < J+B, I > 0.

% goal
:- not goal(length).

goal(T):- holds(at(3,2,1,l2), T). 

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T). 

#show goal/1.
#show occ/2.