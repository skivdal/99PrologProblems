:- ['1-lists'].

/* Problem 1: Determine whether a given integer number is prime */
is_prime(1) :- !, fail.
is_prime(2) :- !.
is_prime(N) :- X is ceiling(sqrt(N)), range(2, X, DS), forall(select(D, DS, _), (Y is (N mod D), Y \= 0)).

