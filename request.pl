:- use_module(library(http/http_client)).
:- use_module(library(http/json)).

api_url("https://jsonplaceholder.typicode.com/todos/1").
% api_url(URL), http_get(URL, Data, []), atom_json_term(Data, json([userId=ID | Lst]), []).
