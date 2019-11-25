:- use_module(request).
:- use_module(translation).

search(Params, Result) :-
    make_yelp_search_request(Params, Res),
    parse_yelp_search_response(Res, Result).

display_results(Result, Lang) :-
    nl(),
    print_businesses(Result, Lang).

print_businesses([], _).
print_businesses([B | Businesses], Lang) :-
    print_business(B, Lang),
    nl(),
    print_businesses(Businesses, Lang).

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
