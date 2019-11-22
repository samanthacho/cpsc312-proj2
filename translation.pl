:- use_module(request).

translate(Query, Translation) :-
    make_translation_request(Query, Response),
    parse_translation_response(Response, Translation).

