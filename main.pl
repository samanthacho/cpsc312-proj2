% User interface. The file that the user runs to make queries.
:- consult(language).

% Main user function
q(Ans) :-
    write("Let's find some food! Ask me: "), flush_output(current_output),
    readln(Ln),
	maplist(downcase_atom, Ln, Ln_lowercase),
    question(Ln_lowercase,End,Ans),
    member(End,[[],['?'],['.']]).
