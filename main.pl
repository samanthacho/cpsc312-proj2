% User interface. The file that the user runs to make queries.
:- consult(language).
:- consult(translation).
:- consult(search).

% Main user function
q() :-
    write("Let's find some food! Ask me: "),
		% flush the buffer
    flush_output(current_output),
		% read the current user input
    readln(Ln),
		% takes the user input and converts it to a string
    atomics_to_string(Ln, " ", Str),
		% translates the user input to english and saves the detected language
    translate(Str, "en", DetectedLang, Translation),
		% takes the translated (english) restult and converts it to a string
    atomics_to_string(TranslationLst, " ", Translation),
		% changes the string to all lower case letters (needed by the knowledge base)
	  maplist(downcase_atom, TranslationLst, TranslationLowercase),
		% parses the parameters for the user input
		% uses once query to only get 1 result
    once(question(TranslationLowercase, End, Ans)),
    member(End, [[]]),
		% uses the parsed parameters to query the Yelp API for a satisfying result
    search(Ans, Result),
		% takes the Result returned and parses the JSON into a user friendly format
    display_results(Result, DetectedLang).
