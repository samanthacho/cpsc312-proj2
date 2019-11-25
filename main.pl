% User interface. The file that the user runs to make queries.
:- consult(language).
:- consult(translation).
:- consult(search).

% Main user function
q() :-
    write("Let's find some food! Ask me: "),
    flush_output(current_output),
    readln(Ln),
    atomics_to_string(Ln, " ", Str),
    translate(Str, "en", DetectedLang, Translation),
    atomics_to_string(TranslationLst, " ", Translation),
	maplist(downcase_atom, TranslationLst, TranslationLowercase),
    question(TranslationLowercase, End, Ans),
    member(End, [[]]),
    search(Ans, Result),
    display_results(Result, DetectedLang).
