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

/* Problem 13: Run-length encoding of a list (direct solution) */
/* Already did this in 11 i think... */

/* Problem 14: Duplicate the elements of a list */
dupli([], []).
dupli([A | Rest], X) :- dupli(Rest, Y), append([A, A], Y, X).

/* Problem 15: Duplicate the elements of a list a given number of times */
repeating(0, _, []).
repeating(N, A, X) :- M is N - 1, repeating(M, A, Y), append([A], Y, X).

dupli([], _, []).
dupli([A | Rest], N, X) :- dupli(Rest, N, Y), repeating(N, A, Z), append(Z, Y, X).

/* Problem 16: Drop every N'th element from a list */
drop_inner([], _, _, []).
drop_inner([_ | Rest], 0, N, X) :- drop_inner(Rest, N, N, X).
drop_inner([A | Rest], I, N, X) :- J is I - 1, drop_inner(Rest, J, N, Y), append([A], Y, X).

drop(List, N, X) :- drop_inner(List, N, N, X).

/* Problem 17: Split a list into two parts; the length of the first part is given */
split(List, I, [], List) :- I < 1.
split([A | Rest], I, [A | Y], Z) :- split(Rest, I - 1, Y, Z).

/* Problem 18: Extract a slice from a list (both limits included) */
slice(_, I, J, []) :- I < 1; J < 1; I > J.
slice(List, I, J, Y) :- split(List, I - 1, _, Z), split(Z, J - I + 1, Y, _).

/* Problem 19: Rotate a list N places to the left */
rotate(List, N, X) :- length(List, M), N > -1,   split(List, N mod M, Y, Z), append(Z, Y, X).
rotate(List, N, X) :- length(List, M), I is M+N, split(List, I mod M, Y, Z), append(Z, Y, X).

/* Problem 20: Remove the K'th element from a list */
remove_at(X, List, K, R) :- split(List, K - 1, Beg, Y), split(Y, 1, [X], End), append(Beg, End, R).

/* Problem 21: Insert an element at a given position into a list */
insert_at(C, List, N, X) :- split(List, N - 1, Y, Z), append(Y, [C | Z], X).

/* Problem 22: Create a list containing all integers within a given range */
range(I, I, [I]).
range(I, J, X) :- N is I + 1, range(N, J, Y), append([I], Y, X).

/* Problem 23: Extract a given number of randomly selected elements from a list */
rnd_select(_, 0, []).
rnd_select(List, N, [C | Y]) :- length(List, Le), Len is Le + 1, random(1, Len, I), remove_at(C, List, I, R),
                                M is N - 1, rnd_select(R, M, Y).

/* Problem 24: Lotto: Draw N different random numbers from the set 1..M */
lotto(N, M, L) :- range(1, M, X), rnd_select(X, N, L).

/* Problem 25: Generate a random permutation of the elements of a list */
rnd_permu(X, L) :- length(X, N), rnd_select(X, N, L).

