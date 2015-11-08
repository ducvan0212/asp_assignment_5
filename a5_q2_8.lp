% 
% Command: clingo 0 -c length=13 a5_q2_8.lp

% Defining the constants
time(0..length).  
number(0..3). 
location(l1).           location(l2).       % two banks 
oar(0..2).

% X missionaries and Y cannibals, O oars are at location L
fluent(at(X,Y,O,L)):-      number(X),number(Y),location(L),oar(O).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries, Y cannibals and O oars move from one bank to another  
action(cross(I,J,O,L)):- 
   number(I), number(J), oar(O), location(L), I+J <= 2, I+J > 0.

holds(at(M+P,N+Q,O+R, L1),T+1):-  time(T), 
   number(M), number(N), location(L), 
   number(P), number(Q), action(cross(M,N,O,L)), 
   occ(cross(M,N,O,L), T), location(L1),   L!=L1,
   holds(at(P,Q,R,L1), T), oar(O), oar(R).

holds(at(P-M,Q-N,R-O,L),T+1):-
     time(T),
     number(M), number(N), location(L), 
     number(P), number(Q), action(cross(M,N,O,L)), 
     occ(cross(M,N,O,L), T), 
     holds(at(P,Q,R,L), T), oar(O), oar(R).

holds(boat_at(L1),T+1):-
     time(T),
     number(M), number(N), location(L), 
     action(cross(M,N,O,L)), location(L1), L!=L1,
     occ(cross(M,N,O,L), T), oar(O), oar(R).

 
% executability condition
executable(cross(I,J,O,L), T):-
     time(T),
     number(I), number(J), location(L), 
     number(P), number(Q), action(cross(I,J,O,L)), 
     holds(boat_at(L), T),
     holds(at(P, Q, R,L), T),  P>=I, Q>=J, R>=0, oar(O), oar(R).

% initial condition
holds(at(3,3,1,l1),0). 
holds(at(0,0,1,l2),0). 
holds(boat_at(l1),0). 

% constraint
% bad(1,T):-  

:- time(T), action(cross(I,J,O,L)), occ(cross(I,J,O,L), T), not executable(cross(I,J,O,L), T).

%bad(2,T)

:- number(I), number(J), location(L), 
     time(T), holds(at(I,J,O,L), T), I < J, I > 0, O>=0.

% one person can cross with just one oar, but two oars are needed if the boat is to carry 2 people
:- time(T), action(cross(I,J,O,L)), occ(cross(I,J,O,L), T), O<I+J.
     
% goal
:- not goal(length).

goal(T):- holds(at(3,3,2,l2), T). 

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T). 

#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
