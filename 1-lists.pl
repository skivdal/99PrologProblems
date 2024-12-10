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
split(List, I, [], List) :- I < 1, !.
split([A | Rest], I, [A | Y], Z) :- J is I - 1, split(Rest, J, Y, Z).

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
range(I, I, [I]) :- !.
range(I, J, X) :- N is I + 1, range(N, J, Y), append([I], Y, X).

/* Problem 23: Extract a given number of randomly selected elements from a list */
rnd_select(_, 0, []) :- !.
rnd_select(List, N, [C | Y]) :- length(List, Le), Len is Le + 1, random(1, Len, I), remove_at(C, List, I, R),
                                M is N - 1, rnd_select(R, M, Y).

/* Problem 24: Lotto: Draw N different random numbers from the set 1..M */
lotto(N, M, L) :- range(1, M, X), rnd_select(X, N, L).

/* Problem 25: Generate a random permutation of the elements of a list */
rnd_permu(X, L) :- length(X, N), rnd_select(X, N, L).

/* Problem 26: Generate the combinations of K distinct objects chosen from the N elements of a list */
combination(0, _, []) :- !.
combination(N, X, L) :- length(X, Kp), K is Kp + 1, range(1, K, R), select(I, R, _),
                        split(X, I, As, Y), my_last(A, As), M is N - 1,
                        combination(M, Y, Ls), append([A], Ls, L).

/* Problem 27a: Group the elements of a set into 3 disjoint subsets of cardinality 2, 3, and 4. */
group3(X, G1, G2, G3) :- combination(2, X, G1), subtract(X, G1, Y), combination(3, Y, G2), subtract(Y, G2, Z), combination(4, Z, G3).

/* Problem 27b: Group the elements of a set into disjoint subsets (general case) */
group(_, [], []) :- !.
group(X, [N | Rest], [G | Gsp]) :- combination(N, X, G), subtract(X, G, Y), group(Y, Rest, Gsp).

/* Problem 28a: Sorting a list according to length of sublists (short lists first) */

/* Helper function: partition list into L(eft) and R(ight) of A, according to the result of P(redicate).
 * Input predicate must be on form P(A, B, N) where N=0 indicates B left and N=1 indicates B right of A.
 */
partition([], _, _, [], []) :- !.
partition([B | Rest], A, P, [B | L], R) :- call_local(P, (A, B, 0)), partition(Rest, A, P, L, R). % cursed evil hack hack hack (TODO: improve)
partition([B | Rest], A, P, L, [B | R]) :- call_local(P, (A, B, 1)), partition(Rest, A, P, L, R).
partition([B | Rest], A, P, [B | L], R) :- call(P, A, B, 0), partition(Rest, A, P, L, R).
partition([B | Rest], A, P, L, [B | R]) :- call(P, A, B, 1), partition(Rest, A, P, L, R).

quick_sort([], _, []) :- !.
quick_sort([A], _, [A]) :- !.
quick_sort(X, P, Y) :- length(X, Xl), Xle is Xl + 1, random(1, Xle, I), !,
                       remove_at(A, X, I, Z), partition(Z, A, P, L, R),
                       quick_sort(L, P, Ls), quick_sort(R, P, Rs), append(Ls, [A | Rs], Y).

length_order_asc(A, B, 0) :- length(A, La), length(B, Lb), La > Lb.
length_order_asc(A, B, 1) :- length(A, La), length(B, Lb), La =< Lb.

lsort(InList, L) :- quick_sort(InList, length_order_asc, L).

/* Problem 28b: Sorting a list according to length frequency of sublists (rarest first) */
first_el_asc([A | _], [B | _], 0) :- A > B.
first_el_asc([A | _], [B | _], 1) :- A =< B.

% Could of course be done faster with a HashMap etc.
calculate_frequency(X, F) :- quick_sort(X, length_order_asc, Y), maplist(length, Y, Z),
                             encode(Z, Fs), quick_sort(Fs, first_el_asc, F), !.

lookup_freq([], _, _) :- fail.
lookup_freq([[F, X] | _], X, F) :- !.
lookup_freq([_ | Rest], X, F) :- lookup_freq(Rest, X, F).

% credit: https://gist.github.com/jarble/8f8f80fa60b089d551efb0c6a74be45b
% prolog metaprogramming sure is cool
call_local(Definition, Params) :-
  copy_term(Definition, (Params :- Body)),
  call(Body).

len_frequency_order_asc(Freqs, P) :-
  P = (
    (A, B, N) :-
      length(A, La), length(B, Lb),
      lookup_freq(Freqs, La, Fa),
      lookup_freq(Freqs, Lb, Fb),
      !,
      (
        Fa > Fb -> N = 0;
        Fa =< Fb -> N = 1
      )
  ).

lfsort(InList, L) :- calculate_frequency(InList, F), len_frequency_order_asc(F, P),
                     quick_sort(InList, P, L), !.

