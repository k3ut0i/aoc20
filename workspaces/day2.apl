#!/usr/bin/apl

⎕IO←0

∇r←str Sub idx
  r←str[(idx[0]+1)↓⍳idx[1]]
∇

∇r←ParseLine l
  Is←{(⍵∊' -:')/⍳⍴⍵}l ⍝ does ⍸l∊' -:' work?
  A1←l Sub ¯1 Is[0]
  A2←l Sub Is[0] Is[1]
  A3←l Sub Is[1] Is[2]
  A4←l Sub (Is[3], ⍴l)
  r←(⍎⍕A1) (⍎⍕A2) A3 A4
∇

∇r←Valid c
  freq←+/↑(c[2]=c[3])
  r←(c[0]≤freq) ∧ (freq≤c[1])
∇

∇r←Valid1 c
  char1←(↑c[3])[c[0]-1]
  char2←(↑c[3])[c[1]-1]
  r←2|(char1=c[2])+(char2=c[2])
  ⍝ This could work? r←2|+/(c[2]=(↑c[3])[c[0,1]-1])
∇
