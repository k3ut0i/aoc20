#!/usr/bin/apl

⎕IO←0

⍝ use ⍷ to find the positions of twocharachter directions
⍝ then after getting their indices we can get e, w indices
⍝ and remove them from twochar ones. Thus we can construct
⍝ the direction sequence
∇r←parseid str
  all←(⍴str)⍴1 ⍝none of the chars in str are handled
  nws←"nw"⍷str ◊ all←all∧~(nws∨¯1⌽nws)
  nes←"ne"⍷str ◊ all←all∧~(nes∨¯1⌽nes)
  ses←"se"⍷str ◊ all←all∧~(ses∨¯1⌽ses)
  sws←"sw"⍷str ◊ all←all∧~(sws∨¯1⌽sws)
  es←"e"⍷str ◊ es←es∧all
  ws←"w"⍷str ◊  ws←ws∧all
  e←(es/⍳⍴str) ◊ se←(ses/⍳⍴str) ◊ sw←(sws/⍳⍴str)
  w←(ws/⍳⍴str) ◊ nw←(nws/⍳⍴str) ◊ ne←(nes/⍳⍴str)
  r← (((⍴e)⍴0), ((⍴se)⍴1), ((⍴sw)⍴2), ((⍴w)⍴3), ((⍴nw)⍴4), ((⍴ne)⍴5))[⍋e,se,sw,w,nw,ne]
∇

∇r←readinputs file
  ls← parseid ⎕FIO[49] file
  r←ls
∇

⍝ "e" "se" "sw" "w" "nw" "ne"
⍝ 0 1 2 3 4 5
⍝ clock wise numbers 
∇r←hexmap code
⍝  codes←"e" "se" "sw" "w" "nw" "ne"
⍝  code←({⍵≡str}¨codes)/⍳⍴codes
  angle←code×○¯1÷3
  r←(2○angle)+(¯11○1○angle)
∇

∇r←findpoint codeseq
  r←+/hexmap codeseq
∇

∇r←x round n
  ⍝⍝ round x down to n decimal digits
  p←×/n⍴10⍝ why not 10^n
  r←(⌊x×p)÷p
∇

∇r←part1 file
  pss←readinputs file
  ps←{ (findpoint ⍵) round 5}¨pss
  oddmask←{(⌊⍵÷2)≠(⍵÷2)}¨{+/⍵=ps}¨ps
  r←∪oddmask/ps ⍝tiles that are filpped oddnumber of times., black tiles
∇

∇r←neighbours p
  r← {⍵ round 5}¨p+hexmap¨⍳6
∇

∇r←stepgame btiles
  ⍝⍝ make sure elements of btiles are unique
  bt←∪btiles
  all←∪bt,↑,/neighbours¨bt ⍝ all concerned tiles
  nall←{⍴(bt∩neighbours ⍵)}¨all ⍝ black neighbours of these tiles
  next← {((⍵⊃all)∊bt)⊃((⍵⊃nall)=2) (~((⍵⊃nall)=0)∨((⍵⊃nall)>2))}¨⍳⍴all
  r←({↑⍵}¨next)/all
∇
