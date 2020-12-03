⎕IO←0

∇r←readMaze filename
  lines←{⍵='#'} ⎕FIO[49]filename
  r←⊃lines ⍝ ⊃ Disclose primitive.
∇

∇r←maze findPoints slope
  ⍝ find all the y-coordinates possible in range
  ⍝ modulo all the x-coordinates to get the peroidic effect
  ⍝ find all trees in those points
  ny←⌊(⍴maze)[0]÷slope[0]
  py←slope[0]×⍳ny
  px←(⍴maze)[1]|slope[1]×⍳ny
  ⍝  r← px {maze[⍺;⍵]} py ⍝how  do I zip px and py?
  points←py(,¨)px
  r←{maze[(⊃⍵)[0];(⊃⍵)[1]]}¨points
∇

∇r←filename findTrees slope
  maze←readMaze filename
  treeVec←maze findPoints slope
  r←+/treeVec
∇

∇r← part2 filename
  n1←filename findTrees 1 1
  n2←filename findTrees 1 3
  n3←filename findTrees 1 5
  n4←filename findTrees 1 7
  n5←filename findTrees 2 1
  r←×/(n1 n2 n3 n4 n5)
∇
