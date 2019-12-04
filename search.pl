% This file calls the predicates from the request file and returns readable results for the user
:- use_module(request).
:- use_module(translation).

% returns True if Result has the returned parsed response of the Yelp API
% Params is of the form [name='XXX', rating='YYY', ...]
% Result is list of businesses and each busiensss is of the form [name="XXX", URL="YYY", ...]
search(Params, Result) :-
    make_yelp_search_request(Params, Res),
    parse_yelp_search_response(Res, Result).

% returns True if the Resuls are printed in language Lang
display_results(Result, Lang) :-
    nl(),
    print_businesses(Result, Lang).

% returns true if all the businesses are printed in language Lang
print_businesses([], _).
print_businesses([B | Businesses], Lang) :-
    print_business(B, Lang),
    nl(),
    print_businesses(Businesses, Lang).

% returns true if a single business is printed in language Lang
print_business([], _).
print_business([name=Name | L1], Lang) :-
    translate("Name", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Name, Ln),
    writeln(Ln),
    print_business(L1, Lang).
print_business([rating=Rating | L1], Lang) :-
    translate("Rating", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Rating, Ln),
    writeln(Ln),
    print_business(L1, Lang).
print_business([price=Price | L1], Lang) :-
    translate("Price", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Price, Ln),
    writeln(Ln),
    print_business(L1, Lang).
print_business([phone=Phone | L1], Lang) :-
    translate("Phone", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Phone, Ln),
    writeln(Ln),
    print_business(L1, Lang).
print_business([url=Url | L1], Lang) :-
    translate("URL", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Url, Ln),
    writeln(Ln),
    print_business(L1, Lang).
print_business([location=Location | L1], Lang) :-
    translate("Location", Lang, _, Translation),
    atom_concat(Translation, ": ", Part),
    atom_concat(Part, Location, Ln),
    writeln(Ln),
    print_business(L1, Lang).
