
% Defining the constants
time(0..length).  
numberm(0..6). 
numberc(0..3).

location(l1).           location(l2).       % two banks 

% X missionaries and Y cannibals are at location L
fluent(at(X,Y,L)):-      numberm(X),numberc(Y),location(L).

% the boat is at location L
fluent(boat_at(L)):-     location(L).

% X missionaries and Y cannibals move from one bank to another  
action(cross(I,J,L)):- 
    numberm(I), numberc(J), location(L), I+J <= 2, I+J > 0.

% 3 missionaries can convert a cannibal to a missionary
action(convert(I,J,L)):- 
    numberm(I), numberc(J), location(L), I = 3, J = 1.

holds(at(M+1,N-1,L), T+1) :- time(T),
    numberm(M), numberc(N), location(L),
    action(convert(M,N,L)), occ(convert(M,N,L), T).

holds(at(P,Q,L1), T+1) :- time(T),
    numberm(M), numberc(N), location(L),
    numberm(P), numberc(Q), location(L1),   L!=L1,
    action(convert(M,N,L)), occ(convert(M,N,L), T), 
    holds(at(P,Q,L1), T).

holds(boat_at(L1),T+1):-
    time(T),
    numberm(M), numberc(N), location(L), location(L1), 
    action(convert(M,N,L)),
    occ(convert(M,N,L), T),
    holds(boat_at(L1), T).

holds(at(M+P,N+Q,L1),T+1):-  time(T), 
    numberm(M), numberc(N), location(L), 
    numberm(P), numberc(Q), action(cross(M,N,L)), 
    occ(cross(M,N,L), T), location(L1),   L!=L1,
    holds(at(P,Q,L1), T).

holds(at(P-M,Q-N,L),T+1):-
    time(T),
    numberm(M), numberc(N), location(L), 
    numberm(P), numberc(Q), action(cross(M,N,L)), 
    occ(cross(M,N,L), T), 
    holds(at(P,Q,L), T).

holds(boat_at(L1),T+1):-
    time(T),
    numberm(M), numberc(N), location(L), 
    action(cross(M,N,L)), location(L1), L!=L1,
    occ(cross(M,N,L), T).

% executability condition
executable(cross(I,J,L), T):-
    time(T),
    numberm(I), numberc(J), location(L), 
    numberm(P), numberc(Q), action(cross(I,J,L)), 
    holds(boat_at(L), T),
    holds(at(P, Q, L), T), P >= I, Q >= J. 
executable(convert(I,J,L), T):-
    time(T),
    numberm(I), numberc(J), location(L), 
    action(convert(I,J,L)), holds(at(I,J,L), T). 
           
% initial condition
holds(at(3,3,l1),0). 
holds(at(0,0,l2),0). 
holds(boat_at(l1),0).

% constraint
% bad(1,T):-  

:- time(T), action(cross(I,J,L)), occ(cross(I,J,L), T), not executable(cross(I,J,L), T).
:- time(T), action(convert(I,J,L)), occ(convert(I,J,L), T), not executable(convert(I,J,L), T).

%bad(2,T)

:- numberm(I), numberc(J), location(L), time(T), holds(at(I,J,L), T), I < J, I > 0.
 
% goal
:- not goal(length).

goal(T):- numberm(I), numberc(J), holds(at(4,2,l2), T).

1 { occ(A, T): action(A) } 1 :- time(T), not goal(T).

%#show goal/1.
%#show t(F) : holds(F, t).
#show occ/2.
