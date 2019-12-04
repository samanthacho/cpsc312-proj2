% This file contains the API connection for this program. It is responsible for making calls to the Yelp API
% Bing Translate API, and translating the response into a format which is usable for the caller classes.

:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).

% json object representing the response structure of the Translate API
:- json_object translationReqObj(text:string).

translation_api_url(Lang, URL) :-
    atom_concat("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=", Lang, URL).

translation_api_key(Key) :-
    getenv("TRANSLATION_API_KEY", Key).

% returns true if Response is the json response returned by the Bing Translate API
% Query is the string to be translated
% Lang is the language to translate to i.e. English Lang = "en"
make_translation_request(Query, Lang, Response) :-
    translation_api_url(Lang, URL),
    translation_api_key(Key),
    prolog_to_json(translationReqObj(Query), Body),
    http_post(URL, json([Body]), Response, [request_header("Ocp-Apim-Subscription-Key"=Key)]).

% returns true if Result and Lang are in the Translate json response
% json reponse must match the expect response
% Lang is the detected language of the text being translated
% Result is the translated text
parse_translation_response([json([detectedLanguage=json([language=Lang, score=_]), translations=[json([text=Result,  to=_])]])], Result, Lang).

yelp_api_url("https://api.yelp.com/v3/businesses/search?").

yelp_api_key(Key) :-
    getenv("YELP_API_KEY", Key).

% returns True if ParamsStr is the paramtized string part of the URL formed from Params
% Params is of the form [name='XXX', rating='YYY', ...]
% ParamStr is of the form 'name=XXX&rating=YYY'
concat_params(Params, ParamsStr) :-
    atomics_to_string(Params, "&", ParamsStr).

% returns True if ParamURL is the entire URL to make the Yelp API request
% Params is of the form [name='XXX', rating='YYY', ...]
% ParamURL is of the form "https://api.yelp.com/v3/businesses/search?name=XXX&rating=YYY&location=Vancouver"
param_url(Params, ParamURL) :-
    yelp_api_url(URL),
    concat_params(Params, ParamsStr),
    atom_concat(URL, ParamsStr, Part),
    atom_concat(Part, "&location=vancouver", ParamURL).

% returns True if Response is the json response returned by the Yelp API
% Query is of the form [name='XXX', rating='YYY', ...]
make_yelp_search_request(Query, Response) :-
    param_url(Query, URL),
    yelp_api_key(Key),
    http_get(URL, Response, [request_header("Authorization"=Key)]).

% returns true if Result is parsed list of businesses from the Yelp API json response
% Result is list of businesses and each busiensss is of the form [name="XXX", URL="YYY", ...]
parse_yelp_search_response(json([businesses=Businesses, _=_, _=_]), Result) :-
    once(parse_businesses(Businesses, Result)).

% returns True if Result has all the businessses parsed from the json response
parse_businesses([], []).
parse_businesses([B | Businesses], [H | T]) :-
    parse_business(B, H),
    parse_businesses(Businesses, T).

% returns True if Result has a single business is parsed from the json response
parse_business(json(Attributes), Result) :-
    parse_business_helper(Attributes, Result).

% returns true if all Result has the properties name, rating, price, phone url, or location of the business
% Input is similar to result but has other unneeded properties as well
% Result is of the form [name='XXX', rating='YYY', ....]
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

% returns true if Location is parsed from the properties
% Locaion is a string that is the location of the business
parse_location([], "").
parse_location([address1=Location | _], Location).
parse_location([att=_ | T], Location) :-
    att \= address1,
    parse_location(T, Location).
