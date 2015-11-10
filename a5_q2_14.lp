% Command: clingo 0 -c length=11 a5_q2_14.lp

% Defining the constants
time(0..length). 
number(0..3).

location(l1).           location(l2).       % two banks 

% X missionaries and Y cannibals are at location L
fluent(at(X,Y,L)):-      number(X),number(Y),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries and Y cannibals move from one bank to another by boat
action(cross(I,J,L)):- 
    number(I), number(J), location(L), I+J <= 2, I+J > 0.

% When the boat is loaded by 2 people, one of them has to bail
action(bail(I,J,L)):- 
    number(I), number(J), location(L), I+J = 2.

holds(at(M+P,N+Q,L1),T+1):-  time(T), 
    number(M), number(N), location(L), 
    number(P), number(Q), action(cross(M,N,L)), 
    occ(cross(M,N,L), T), location(L1),   L!=L1,
    holds(at(P,Q,L1), T).

holds(at(P-M,Q-N,L),T+1):-
    time(T),
    number(M), number(N), location(L), 
    number(P), number(Q), action(cross(M,N,L)), 
    occ(cross(M,N,L), T), 
    holds(at(P,Q,L), T).

holds(boat_at(L1),T+1):-
    time(T),
    number(M), number(N), location(L), 
    action(cross(M,N,L)), location(L1), L!=L1,
    occ(cross(M,N,L), T).

% executability condition
executable(cross(I,J,L), T):-
    time(T),
    number(I), number(J), location(L), 
    number(P), number(Q), action(cross(I,J,L)), 
    holds(boat_at(L), T),
    holds(at(P, Q, L), T), P >= I, Q >= J. 
executable(bail(I,J,L), T):-
    time(T),
    number(I), number(J), location(L), 
    number(P), number(Q), action(bail(I,J,L)), 
    holds(at(P, Q, L), T), P >= I, Q >= J.
           
% initial condition
holds(at(3,3,l1),0). 
holds(at(0,0,l2),0). 
holds(boat_at(l1),0).

% constraint
% bad(1,T):-  

:- time(T), action(cross(I,J,L)), occ(cross(I,J,L), T), not executable(cross(I,J,L), T).
:- time(T), action(bail(I,J,L)), occ(bail(I,J,L), T), not executable(bail(I,J,L), T).

%bad(2,T)

:- number(I), number(J), location(L), time(T), holds(at(I,J,L), T), I < J, I > 0.
 
% goal
:- not goal(length).

goal(T):- number(I), number(J), holds(at(3,3,l2), T).

1 { occ(cross(I,J,L), T): action(cross(I,J,L)) } 1 :- time(T), not goal(T).

% bailing occurs when boat has 2 people crossing at time T.
occ(bail(I,J,L), T):- occ(cross(I,J,L), T), I+J=2.

%#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
