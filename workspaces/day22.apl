#!/usr/bin/apl

⎕IO←0

∇r← readinputs file
  ls← ⎕FIO[49] file
  empty←({⍵≡""}¨ls) ⍝ empty lines
  parts←(~empty) ⊂ ⍳⍴ls
  r←{ls[⍵]}¨parts
∇

∇r←parsedeck ls
  ⍝ ignore ls[0]
  plno←⍎(0 7 ⊃ ls)
  r←plno ({⍎⍵}¨1↓ls)
∇

∇r←parseinputs file
  decks←parsedeck¨readinputs file
  r←decks
∇

∇r←stepgame decks
  ⍝ ⎕←decks
  d1←(0 1⊃decks),⍬
  d2←(1 1⊃decks),⍬
  l1←¯1+⍴d1
  l2←¯1+⍴d2
  cond←d1[0]>d2[0]
  m1←(l1⍴1), 2⍴cond
  m2←(l2⍴1), ~2⍴cond 
  d1n←m1/1↓d1, d1[0], d2[0]
  d2n←m2/1↓d2, d2[0], d1[0]
  r←((0 0⊃decks) d1n) ((1 0⊃decks) d2n)
∇

∇r←completedp decks
  r←(0=⍴(0 1⊃decks))∨(0=⍴(1 1⊃decks))
∇

⍝ NOT necessary but I need to figure GOTO's out.
⍝ ∇r←safestep decks
⍝   →(completedp decks)/completed
⍝   r←(stepgame decks)
⍝   → end
⍝   completed:
⍝   r←decks
⍝   end:
⍝ ∇

∇r←rungame decks
  r←(stepgame ⍣ {completedp (⍺⊣⍵)}) decks
∇

∇r←winningdeck decks
  d1←0 1⊃decks◊d2←1 1⊃decks
  r←(0=⍴d1)⊃d1 d2
∇

∇r←scoredeck deckseq
  r←+/deckseq {⍺×⍵} ⌽1↓⍳1+⍴(deckseq)
∇

∇r←part1 file
  decks←parseinputs file
  final←rungame decks
  r←scoredeck winningdeck final
∇
