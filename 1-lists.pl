/* Problem 1: last element of list */
my_last(X, [X]).
my_last(X, [_ | Rest]) :- my_last(X, Rest).

/* Problem 2: find the last but one element of a list */
penultimate(X, [X | [_ | []]]).
penultimate(X, [_ | Rest]) :- penultimate(X, Rest).

/* Problem 3: Find the K'th element of a list */
element_at(X, [X | _], 1).
element_at(X, [_ | Rest], K) :- Ka is K - 1, element_at(X, Rest, Ka).

/* Problem 4: Find the number of elements in a list */
list_len(0, []).
list_len(X, [_ | Rest]) :- list_len(Y, Rest), X is Y + 1.

/* Problem 5: Reverse a list */
list_rev([], []).
list_rev(X, [A | Rest]) :- list_rev(Y, Rest), append(Y, [A], X).

/* Problem 6: Find out whether a list is a palindrome */
is_palindrome(X) :- list_rev(Y, X), X == Y.

/* Problem 7: Flatten a nested list structure */
my_flatten([], []).
my_flatten([A | Rest], X) :- is_list(A), !, my_flatten(A, Ap), my_flatten(Rest, Y), append(Ap, Y, X).
my_flatten([A | Rest], X) :- my_flatten(Rest, Y), append([A], Y, X).

/* Problem 8: Eliminate consecutive duplicates of list elements */
compress([], []).
compress([A], [A]).
compress([A | Rest], X) :- compress(Rest, Y), [F | _] = Y, A \= F, append([A], Y, X).
compress([_ | Rest], X) :- compress(Rest, X).

