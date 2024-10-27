/* Problem 1: last element of list */
my_last(X, [X]).
my_last(X, [_ | Rest]) :- my_last(X, Rest).

