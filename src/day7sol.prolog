isIn(A, B, Count) :- contains(B, A, Count).
isIn(A, B, Count) :-
    contains(B, C, Count1),
    isIn(A, C, Count2), Count is Count1 * Count2.

all_bags_in(A, Count) :-
    findall(N, isIn(_, A, N), Ns),
    sum_list(Ns, Count).
