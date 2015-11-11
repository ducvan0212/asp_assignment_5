% Defining the constants
time(0..length).  
number(0..4). 

location(l1).           location(l2).       % two banks 
location(l3).
% X missionaries and Y cannibals are at location L
fluent(at(X,Y,L)):-      number(X),number(Y),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries and Y cannibals move from one bank to another  
action(cross(I,J,L,L1)):- 
   number(I), number(J),location(L1), location(L), I+J <= 2, I+J > 0, L!=L1.

holds(at(P,Q,L),T+1):-  time(T), 
   number(M), number(N), location(L), location(L2), 
   number(P), number(Q), action(cross(M,N,L1,L2)), 
   occ(cross(M,N,L1,L2), T), location(L1),   L!=L1, L!=L2,
   holds(at(P,Q,L), T).

holds(at(M+P,N+Q,L1),T+1):-  time(T), 
   number(M), number(N), location(L), 
   number(P), number(Q), action(cross(M,N,L,L1)), 
   occ(cross(M,N,L,L1), T), location(L1),   L!=L1,
   holds(at(P,Q,L1), T).

holds(at(P-M,Q-N,L),T+1):-
     time(T),location(L1), 
     number(M), number(N), location(L), 
     number(P), number(Q), action(cross(M,N,L,L1)), 
     occ(cross(M,N,L,L1), T), L!=L1, 
     holds(at(P,Q,L), T).

holds(boat_at(L1),T+1):-
     time(T),
     number(M), number(N), location(L), 
     action(cross(M,N,L,L1)), location(L1), L!=L1,
     occ(cross(M,N,L,L1), T).

 
% executability condition
executable(cross(I,J,L,L1), T):-
     time(T),
     number(I), number(J), location(L), 
     number(P), number(Q), action(cross(I,J,L,L1)), 
     holds(boat_at(L), T), location(L1),
     holds(at(P, Q, L), T) ,P>=I, Q>=J.
% initial condition
holds(at(4,4,l1),0). 
holds(at(0,0,l2),0).
holds(at(0,0,l3),0). 
holds(boat_at(l1),0). 

% constraint
% bad(1,T):-  

:- time(T), action(cross(I,J,L,L1)), occ(cross(I,J,L,L1), T), not executable(cross(I,J,L,L1), T).

%bad(2,T)

:- number(I), number(J), location(L), time(T), holds(at(I,J,L), T), I < J, I > 0.
 
% goal
:- not goal(length).

goal(T):- holds(at(4,4,l2), T). 

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T).

%occ(cross(1,1,l1), 0). 
%occ(cross(1,0,l2), 1).
%occ(cross(0,2,l1), 2).
%occ(cross(0,1,l2), 3). 
%occ(cross(2,0,l1), 4).
%occ(cross(1,1,l2), 5). 
%occ(cross(2,0,l1), 6).
%occ(cross(0,1,l2), 7). 
%occ(cross(0,2,l1), 8).
%occ(cross(0,1,l2), 9). 
%occ(cross(0,2,l1), 10).
 

#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
