% Command: clingo 0 -c length=3 a5_q2_13.lp

% Defining the constants
time(0..length). 
number(0..3).

location(l1).           location(l2).       % two banks 

% X missionaries and Y cannibals are at location L
fluent(at(X,Y,L)):-      number(X),number(Y),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries and Y cannibals move from one bank to another by boat
action(x_by_boat(I,J,L)):- 
    number(I), number(J), location(L), I+J <= 2, I+J > 0.

% X missionaries and Y cannibals move from one bank to another by bridge
action(x_by_bridge(I,J,L)):- 
    number(I), number(J), location(L), I+J <= 2, I+J > 0.

holds(at(M+P,N+Q,L1),T+1):-  time(T), 
    number(M), number(N), location(L), 
    number(P), number(Q), action(x_by_bridge(M,N,L)), 
    occ(x_by_bridge(M,N,L), T), location(L1),   L!=L1,
    holds(at(P,Q,L1), T).
    
holds(at(P-M,Q-N,L),T+1):-
    time(T),
    number(M), number(N), location(L), 
    number(P), number(Q), action(x_by_bridge(M,N,L)), 
    occ(x_by_bridge(M,N,L), T), 
    holds(at(P,Q,L), T).

holds(boat_at(L),T+1):-
    time(T),
    number(M), number(N), location(L), 
    action(x_by_bridge(M,N,L)),
    occ(x_by_bridge(M,N,L), T).

holds(at(M+P,N+Q,L1),T+1):-  time(T), 
    number(M), number(N), location(L), 
    number(P), number(Q), action(x_by_boat(M,N,L)), 
    occ(x_by_boat(M,N,L), T), location(L1),   L!=L1,
    holds(at(P,Q,L1), T).

holds(at(P-M,Q-N,L),T+1):-
    time(T),
    number(M), number(N), location(L), 
    number(P), number(Q), action(x_by_boat(M,N,L)), 
    occ(x_by_boat(M,N,L), T), 
    holds(at(P,Q,L), T).

holds(boat_at(L1),T+1):-
    time(T),
    number(M), number(N), location(L), 
    action(x_by_boat(M,N,L)), location(L1), L!=L1,
    occ(x_by_boat(M,N,L), T).

% executability condition
executable(x_by_boat(I,J,L), T):-
    time(T),
    number(I), number(J), location(L), 
    number(P), number(Q), action(x_by_boat(I,J,L)), 
    holds(boat_at(L), T),
    holds(at(P, Q, L), T), P >= I, Q >= J. 
executable(x_by_bridge(I,J,L), T):-
    time(T),
    number(I), number(J), location(L), 
    number(P), number(Q), action(x_by_bridge(I,J,L)), 
    holds(at(P, Q, L), T), P >= I, Q >= J.
           
% initial condition
holds(at(3,3,l1),0). 
holds(at(0,0,l2),0). 
holds(boat_at(l1),0).

% constraint
% bad(1,T):-  

:- time(T), action(x_by_boat(I,J,L)), occ(x_by_boat(I,J,L), T), not executable(x_by_boat(I,J,L), T).
:- time(T), action(x_by_bridge(I,J,L)), occ(x_by_bridge(I,J,L), T), not executable(x_by_bridge(I,J,L), T).

%bad(2,T)

:- number(I), number(J), location(L), time(T), holds(at(I,J,L), T), I < J, I > 0.
 
% goal
:- not goal(length).

goal(T):- number(I), number(J), holds(at(3,3,l2), T).

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T).

%#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
