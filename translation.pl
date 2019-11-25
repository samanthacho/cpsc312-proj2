:- consult(request).

translate(Query, ToLang, FromLang, Translation) :-
    make_translation_request(Query, ToLang, Response),
    parse_translation_response(Response, Translation, FromLang).

