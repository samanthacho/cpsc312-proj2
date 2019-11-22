% Modified language script
:- consult(kb).

% Create/append element of a list, used for constructing the list of search parameters
append([],X,X).
append([X|Y],Z,[X|W]) :- append(Y,Z,W).

% Question definition; used to create the list of parameters.
question(T0, T2, Params) :-
  starter_phrase(T0, T1),
  noun_phrase(T1,T2,Params).

% Starter phrases to parse out from the query to only leave elements we care about.
starter_phrase(['what', Verb | T], T) :-
  to_be_conj(Verb).
starter_phrase(['what', '\'', 's' | T], T).
starter_phrase([Imperative | T], T) :-
  imperative(Imperative).
starter_phrase([Imperative, Asker | T], T) :-
  imperative(Imperative),
  asker(Asker).
starter_phrase(['search', 'for' | T], T).

to_be_conj(is).
to_be_conj(are).

imperative('find').
imperative('give').
imperative('show').
imperative('suggest').

asker('me').
asker('us').

% a noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional prepositional phrase.
noun_phrase(L0,L4,Params) :-
   det(L0,L1,P1),
   adjectives(L1,L2,P2),
   noun(L2,L3),
   pp(L3,L4),
   append([P1],P2,Params).

% an optional noun phrase is either nothing or a noun phrase
opt_noun_phrase(L,L).
opt_noun_phrase(L0,L1) :-
   noun_phrase(L0,L1,_).

% a verb phrase is a verb followed by a noun phrase and an optional pp
verb_phrase(L0,L3) :-
   verb(L0,L1),
   opt_noun_phrase(L1,L2),
   pp(L2,L3).

% an optional prepositional phrase is either
% nothing or a preposition followed by a noun phrase
pp(L,L).
pp(L0,L2) :-
   preposition(L0,L1),
   noun_phrase(L1,L2,_).

% adjectives is a sequence of adjectives
adjectives([','|T1],T2,T) :-
    adjectives(T1,T2,T).
adjectives(T0,T2,[FirstParam|T]) :-
    adj(T0,T1,FirstParam),
    adjectives(T1,T2,T).
adjectives(T,T,[]).
