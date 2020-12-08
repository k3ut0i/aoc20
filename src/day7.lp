isIn(A, B, Count) :- contains(B, A, Count).
isIn(A, B, Count) :- contains(B, C, Count1), isIn(A, C, Count2), Count = Count1 * Count2.

sgIsIn(X) :- isIn(shiny_gold, X, _).

shinyInBags(N) :- #count { X : sgIsIn(X) } = N.

% Answer of part1
#show shinyInBags/1.

bagsInShiny(N) :- #sum { Count : isIn(A, shiny_gold, Count) } = N.

#show bagsInShiny/1.
