% Modified language script
:- [language].
:- [kb].

% Main user function
q(Ans) :-
    write("Let's find some food! Ask me: "), flush_output(current_output),
    readln(Ln),
	maplist(downcase_atom, Ln, Ln_lowercase),
    question(Ln_lowercase,End,Ans),
    member(End,[[],['?'],['.']]).

question(T0, T2, Params) :-
  starter_phrase(T0, T1),
  noun_phrase(T1,T2,Params).
