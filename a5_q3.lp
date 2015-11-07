% Command: clingo -c length=5 a5_q3.lp
% Test Scenario 1: 
%occ(action(close_valve), 1).
%occ(action(open_valve), 3).

% Test Scenario 2: 
%occ(action(turn_switch_on), 1).
%occ(action(turn_switch_off), 3).

% Assignment Scenario 1: 
%occ(action(close_valve), 1).
%occ(action(turn_switch_on), 2).

% Assignment Scenario 2: 
occ(action(turn_switch_on), 1).
occ(action(close_valve), 2).
occ(action(turn_switch_on), 3).

% Defining the constants
time(0..length).  

switch_is(on; off). 
valve_is(opened; closed). 
car_is(running; damaged).
engine_is(on; off).
engine_has(gasoline; nogas).
engine_got_damaged(yes; no).
battery_is(alive; dead).
tank_has(gasoline; nothing).

%
fluent(switch(X))             :- switch_is(X).
fluent(valve(X))              :- valve_is(X).
fluent(engine(X))             :- engine_is(X).
fluent(car(running))          :- car_is(running).
fluent(gasoline_available(G)) :- engine_has(G).
fluent(damaged(D))            :- engine_got_damaged(D).
fluent(tank(G))               :- tank_has(G).
% 
action(turn_switch_on)  :- switch_is(off).
action(turn_switch_off) :- switch_is(on).
action(open_valve)      :- valve_is(closed).
action(close_valve)     :- valve_is(opened) .

% The switch can be toggled between the on and the off position.
holds(switch(on),T+1):-  time(T), 
    action(turn_switch_on), 
    occ(action(turn_switch_on), T),
    holds(switch(off), T).

holds(switch(off),T+1):-  time(T), 
    action(turn_switch_off), 
    occ(action(turn_switch_off), T),
    holds(switch(on), T).

% The valve can be toggled between the opened and the closed position.
holds(valve(opened),T+1):-  time(T), 
    action(open_valve), 
    occ(action(open_valve), T),
    holds(valve(closed), T).

holds(valve(closed),T+1):-  time(T), 
    action(close_valve), 
    occ(action(close_valve), T),
    holds(valve(opened), T).

% When the valve is closed then gasoline is supplied from the tank to the engine. We assume that the tank always has gasoline.   
holds(gasoline_available(gasoline), T) :- time(T),
    holds(valve(closed), T),
    holds(tank(gasoline), T).

% When the swith is at the on/off position, the engine is on/off.
holds(engine(S), T) :- time(T),
    holds(switch(S),T).

% When the engine is on and the valve is closed then the car will run.  
holds(car(running), T) :- time(T),
    holds(engine(on), T),
    holds(gasoline_available(gasoline), T),
    holds(damaged(no), T).

% When the engine is on and the valve is open then the car will be damaged.  
holds(damaged(yes), T) :- time(T),
    holds(engine(on), T),
    holds(valve(opened), T).

% When the engine is damaged then the car will not run.  
holds(car(damaged), T) :- time(T),
    holds(damaged(yes), T).

% Frame problem. If valve is NOT closed/opened in time T then it remains opened/closed in time T+1
holds(valve(opened), T+1) :- time(T),
    holds(valve(opened), T),
    action(close_valve),
    not occ(action(close_valve), T).

holds(valve(closed), T+1) :- time(T),
    holds(valve(closed), T),
    action(open_valve),
    not occ(action(open_valve), T).
   
% Frame problem. If switch is NOT turned off/on in time T then it remains on/off in time T+1
holds(switch(on), T+1) :- time(T),
    holds(switch(on), T),
    action(turn_switch_off),
    not occ(action(turn_switch_off), T).

holds(switch(off), T+1) :- time(T),
    holds(switch(off), T),
    action(turn_switch_on),
    not occ(action(turn_switch_on), T).

% If engine is damaged then there is no way to recover it.
holds(damaged(yes), T+1) :- time(T),
    holds(damaged(yes), T).

% If engine is NOT damaged then it is ok in time T.    
holds(damaged(no), T) :- time(T),
    not holds(damaged(yes), T).

% Expressing what we do not state as true are false!
holds(neg(F),0) :- fluent(F), not holds(F,0).

% initial condition
holds(valve(opened),0). 
holds(switch(off),0). 
% tank always has gasoline.
holds(tank(gasoline), T) :- time(T).
% engine is not damaged
holds(damaged(no),0).
% gasoline is not available
holds(gasoline_available(nogas), 0).

% constraint
% bad(1,T):-  

% goal

1 { occ(A, T): action(A) } 1 :- time(T). 

#show holds/2.
