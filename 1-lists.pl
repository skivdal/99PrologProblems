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

/* Problem 9: Pack consecutive duplicates of list elements into sublists */
pack([], []).
pack([A], [[A]]).
pack([A | Rest], X) :- pack(Rest, Y), [[F | _] | _] = Y, A \= F, append([[A]], Y, X).
pack([A | Rest], X) :- pack(Rest, Y), [G | RR] = Y, append([A], G, NF), append([NF], RR, X).

/* Problem 10: Run-length encoding of a list */
encode([], []).
encode([A], [[1, A]]).
encode([A | Rest], X) :- encode(Rest, Y), [[N, A] | RR] = Y, M is N + 1, append([[M, A]], RR, X).
encode([A | Rest], X) :- encode(Rest, Y), append([[1, A]], Y, X).

/* Problem 11: Modified run-length encoding */
encode_modified([], []).
encode_modified([A], [A]).

encode_modified([A | Rest], X) :- encode_modified(Rest, Y), [[N, A] | RR] = Y, M is N + 1, append([[M, A]], RR, X).
encode_modified([A | Rest], X) :- encode_modified(Rest, Y), [[_, B] | _ ] = Y, B \= A,     append([A], Y, X).

encode_modified([A | Rest], X) :- encode_modified(Rest, Y), [A | RR] = Y,         append([[2, A]], RR, X).
encode_modified([A | Rest], X) :- encode_modified(Rest, Y), [B | _ ] = Y, B \= A, append([A], Y, X).

/* Problem 12: Decode a run-length encoded list. (As encoded by encode_modified) */
decode([], []).

decode([[1, A] | Rest], X) :- decode(Rest, Y), append([A], Y, X).
decode([[N, A] | Rest], X) :- M is N - 1, decode([[M, A] | Rest], Y), append([A], Y, X).

decode([A | Rest], X) :- decode(Rest, Y), append([A], Y, X).

