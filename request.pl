:- use_module(library(http/http_client)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json_convert)).

:- json_object translationReqObj(text:string).

translation_api_url("https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&to=en").

translation_api_key(Key) :-
    getenv("TRANSLATION_API_KEY", Key).

make_translation_request(Query, Response) :-
    translation_api_url(URL),
    translation_api_key(Key),
    prolog_to_json(translationReqObj(Query), Body),
    http_post(URL, json([Body]), Response, [request_header("Ocp-Apim-Subscription-Key"=Key)]).

parse_translation_response([json([detectedLanguage=json([language=_, score=_]), translations=[json([text=Result,  to=_])]])], Result).


