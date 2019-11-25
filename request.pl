:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).

:- json_object translationReqObj(text:string).

translation_api_url(Lang, URL) :-
    atom_concat("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=", Lang, URL).

translation_api_key(Key) :-
    getenv("TRANSLATION_API_KEY", Key).

make_translation_request(Query, Lang, Response) :-
    translation_api_url(Lang, URL),
    translation_api_key(Key),
    prolog_to_json(translationReqObj(Query), Body),
    http_post(URL, json([Body]), Response, [request_header("Ocp-Apim-Subscription-Key"=Key)]).

parse_translation_response([json([detectedLanguage=json([language=Lang, score=_]), translations=[json([text=Result,  to=_])]])], Result, Lang).

yelp_api_url("https://api.yelp.com/v3/businesses/search?").

yelp_api_key(Key) :-
    getenv("YELP_API_KEY", Key).

concat_params(Params, ParamsStr) :-
    atomics_to_string(Params, "&", ParamsStr).

param_url(Params, ParamURL) :-
    yelp_api_url(URL),
    concat_params(Params, ParamsStr),
    atom_concat(URL, ParamsStr, Part),
    atom_concat(Part, "&location=vancouver", ParamURL).

make_yelp_search_request(Query, Response) :-
    param_url(Query, URL),
    yelp_api_key(Key),
    http_get(URL, Response, [request_header("Authorization"=Key)]).

parse_yelp_search_response(json([businesses=Businesses, _=_, _=_]), Result) :-
    once(parse_businesses(Businesses, Result)).

parse_businesses([], []).
parse_businesses([B | Businesses], [H | T]) :-
    parse_business(B, H),
    parse_businesses(Businesses, T).

parse_business(json(Attributes), Result) :-
    parse_business_helper(Attributes, Result).

parse_business_helper([], []).
parse_business_helper([name=Name | L1], [name=Name | L2]) :-
    parse_business_helper(L1, L2).
parse_business_helper([rating=Rating | L1], [rating=Rating | L2]) :-
    parse_business_helper(L1, L2).
parse_business_helper([price=Price | L1], [price=Price | L2]) :-
    parse_business_helper(L1, L2).
parse_business_helper([display_phone=Phone | L1], [phone=Phone | L2]) :-
    parse_business_helper(L1, L2).
parse_business_helper([url=Url | L1], [url=Url | L2]) :-
    parse_business_helper(L1, L2).
parse_business_helper([location=json(LocAttributes) | L1], [location=Location | L2]) :-
    parse_location(LocAttributes, Location),
    parse_business_helper(L1, L2).
parse_business_helper([Term=_ | L1], L2) :-
    \+ member(Term, [name, rating, price, display_phone, url]),
    parse_business_helper(L1, L2).

parse_location([], "").
parse_location([address1=Location | _], Location).
parse_location([att=_ | T], Location) :-
    att \= address1,
    parse_location(T, Location).
