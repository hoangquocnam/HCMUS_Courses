globals [
  FIFO
  LIFO
  open
  closed
  optimal-path
]

turtles-own [
  path
  current-path


]

patches-own
[
  parent-patch
  f
  g
  h
  algorithm_own
]

to set-up
  clear-all
  create-source-and-destination
end

to create-source-and-destination
  if Levels = "level 1"[
    ask patches [set pcolor  blue + 3]
    ask one-of patches with [pcolor =  blue + 3]
    [
      set plabel "source"
      set pcolor magenta
      sprout 1
      [
        set color red
        set shape icon
        set size 3
      ]
    ]



    ask one-of patches with [pcolor =  blue + 3]
    [
      set pcolor green
      set plabel "destination"

    ]
  ]

  if Levels = "level 2"[
    ask patches [set pcolor  blue + 3]
    ask one-of patches with [pcolor =  blue + 3]
    [
      set plabel "source"
      set pcolor magenta
      sprout 1
      [
        set color red
        set shape icon
        set size 3

      ]
    ]



    ask one-of patches with [pcolor =  blue + 3 and plabel != "source"]
    [
      set pcolor green
      set plabel "destination"
    ]

  ]

  if Levels = "level 3"[

    ask patches [set pcolor  blue + 3]
    let index 1
    while [index <= number_of_agents][

      ask one-of patches with [pcolor =  blue + 3 and pcolor != magenta]
      [
        set plabel index
        set pcolor magenta
        sprout 1
        [
          set color red
          set shape icon
          set size 3
        ]

      ]
      set index index + 1

    ]




    ask one-of patches with [pcolor =  blue + 3 and pcolor != magenta]
    [
      set pcolor green
      set plabel "destination"
    ]
  ]


end

to draw-maze
  if mouse-inside?
    [
      ask patch mouse-xcor mouse-ycor
      [
        sprout 1
        [
          die
        ]
      ]

      ;draw obstacles
      if Select-element = "obstacles"
      [
        if mouse-down?
        [
          if [pcolor] of patch mouse-xcor mouse-ycor = blue + 3 or [pcolor] of patch mouse-xcor mouse-ycor = brown or [pcolor] of patch mouse-xcor mouse-ycor = yellow
          [
            ask patch mouse-xcor mouse-ycor
            [
              set pcolor white
            ]
          ]
        ]
      ]

      ;erase obstacles
      if Select-element = "erase obstacles"
      [
        if mouse-down?
        [
          if [pcolor] of patch mouse-xcor mouse-ycor = white
          [
            ask patch mouse-xcor mouse-ycor
            [
              set pcolor blue + 3
            ]
          ]
        ]
      ]

      ;draw source patch
      if Select-element = "source" and Levels != "level 3"
      [
        if mouse-down?
        [
          let m-xcor mouse-xcor
          let m-ycor mouse-ycor
          if [plabel] of patch m-xcor m-ycor != "destination"
          [
            ask patches with [plabel = "source"]
            [
              set pcolor blue + 3
              set plabel ""
            ]
            ask turtles
            [
              die
            ]
            ask patch m-xcor m-ycor
            [
              set pcolor magenta
              set plabel "source"
              sprout 1
              [
                set color red
                set shape icon
                set size 3

              ]
            ]
          ]
        ]
      ]

      ;draw destination patch
      if Select-element = "destination"
        [
          if mouse-down?
            [
              let m-xcor mouse-xcor
              let m-ycor mouse-ycor

              if [plabel] of patch m-xcor m-ycor != "source"
              [
                ask patches with [plabel = "destination"]
                [
                  set pcolor blue + 3
                  set plabel ""
                ]
                ask patch m-xcor m-ycor
                [
                  set pcolor green
                  set plabel "destination"
                ]
              ]
            ]
        ]
    ]
end

to clear-view [source destination]
  cd
  ask patches with[pcolor = yellow or pcolor = black or pcolor = brown or pcolor = 26]
  [
    set pcolor blue + 3
  ]

  ask patches with[ plabel = destination] [
    ask turtles with [color = red] [die]
    set pcolor green
  ]

  ask one-of patches with [plabel = source ]
  [
    set plabel source
    set pcolor magenta
    sprout 1
    [
      set color red
      set shape icon
      set size 3

    ]
  ]

  if Levels = "level 3"[
    let count-source count patches with [pcolor >= 121 and pcolor <= 129]
    if count-source > 1 [
      let index 1
      while [index <= count-source][
        ask one-of patches with [plabel = index]
        [
          set plabel index
          set pcolor magenta

        ]
        set index index + 1

      ]
    ]

  ]

end

to move [source-patch destination-patch]
  ask one-of turtles
  [
    while [length current-path != 0]
    [
      go-to-next-patch-in-current-path source-patch destination-patch
      pd
      wait 0.05
    ]
    if length current-path = 0
    [
      pu
    ]
    pd
  ]
end

to go-to-next-patch-in-current-path [source-patch destination-patch]
  face first current-path
  repeat 10
  [
    fd 0.1
  ]
  move-to first current-path
  if [plabel] of patch-here != source-patch and  [plabel] of patch-here != destination-patch
  [
    ask patch-here
    [
      set pcolor black
    ]
  ]
  set current-path remove-item 0 current-path
end

to load-maze

  if name_file_load != false
  [
    ifelse (item (length name_file_load - 1) name_file_load = "g" and item (length name_file_load - 2) name_file_load = "n" and item (length name_file_load - 3) name_file_load = "p" and item (length name_file_load - 4) name_file_load = ".")
    [
      clear-all
      import-pcolors name_file_load
      ifelse count patches with [pcolor = magenta] >= 1 and count patches with [pcolor = green] >= 1
      [

        ask patches
        [
          set plabel ""
        ]
        ask turtles
        [
          die
        ]
        let count-source count patches with [pcolor >= 121 and pcolor <= 129]
        set number_of_agents count-source
        if count-source > 1 [
          let index 1
          while [index <= count-source][
            ask one-of patches with [pcolor >= 121 and pcolor <= 129 and plabel = ""]
            [
              set plabel index
              set pcolor magenta
              sprout 1
              [
                set color red
                set shape icon
                set size 3
              ]

            ]
            set index index + 1

          ]



          ask one-of patches with [pcolor = green]
          [
            set plabel "destination"
          ]
        ]


        if count-source = 1[
          ask one-of patches with [pcolor = magenta]
          [
            set plabel "source"
            sprout 1
            [
              set color red
              set shape icon
              set size 3
              pd
            ]
          ]
        ]

        ask one-of patches with [pcolor = green]
        [
          set plabel "destination"
        ]
      ]
      [
        clear-all
        user-message "The selected image is not a valid maze."
        load-maze
        ;;clear-view
      ]
    ]
    [
      user-message "The selected file is not a valid image."
    ]
  ]
end

to save-maze
  if any? patches with [pcolor != black]
  [
    clear-unwanted-elements
    export-view name_file_save
  ]
end

to clear-unwanted-elements
  if any? patches with [pcolor = brown or pcolor = yellow or pcolor = black]
  [
    ask patches with [pcolor = brown or pcolor = yellow or pcolor = black ]
    [
      set pcolor blue + 3
    ]
  ]
  if any? patches with [plabel ="source"]
  [
    ask one-of patches with [plabel ="source"]
    [
      set pcolor magenta
    ]
  ]

  let index 1
  while [index <= number_of_agents][
    if any? patches with [plabel ="index"]
    [
      ask one-of patches with [plabel ="index"]
      [
        set pcolor magenta
      ]
    ]
    set index index + 1
  ]


  if any? patches with [plabel ="destination"]
  [
    ask one-of patches with [plabel ="destination"]
    [
      set pcolor green
    ]
  ]

  if any? patches with [plabel ="destination 1"]
  [
    ask one-of patches with [plabel ="destination 1"]
    [
      set pcolor green
    ]
  ]

   if any? patches with [plabel ="destination 2"]
  [
    ask one-of patches with [plabel ="destination 2"]
    [
      set pcolor green
    ]
  ]


  clear-drawing
  ask turtles
  [
    die
  ]
end

to BFS [source-patch destination-patch]
  clear-view source-patch destination-patch
  set FIFO []
  set FIFO lput one-of patches with [plabel = source-patch] FIFO

  ask one-of turtles
  [
    set path run-BFS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
  ]
  wait 1
  ask patches with[pcolor = yellow or pcolor = brown]
  [
    set pcolor blue + 3
  ]
  move source-patch destination-patch
end

to-report run-BFS [source-patch destination-patch]
  let BFSpath []
  let path-to-destination []
  ask first FIFO [
    set parent-patch first FIFO
  ]
  while [not empty? FIFO] [
    let current-patch first FIFO

    set FIFO remove-item 0 FIFO

    if not member? current-patch BFSpath[
      set BFSpath lput current-patch BFSpath
    ]
    if [plabel] of current-patch = [plabel] of destination-patch
    [
      set current-patch [parent-patch] of current-patch
      while [current-patch != [parent-patch] of current-patch] [
        set path-to-destination fput current-patch path-to-destination
        ask current-patch[
          set pcolor 26
        ]
        set current-patch [parent-patch] of current-patch

      ]
      report path-to-destination
    ]

    ask current-patch[
      set pcolor brown
      if plabel = [plabel] of source-patch [
        set pcolor magenta
      ]
      ask neighbors4 with [pcolor != white and pcolor != yellow and not member? self BFSpath and pxcor >= min-pxcor and pycor >= min-pycor and pxcor <= max-pxcor and pycor <= max-pycor][
        set parent-patch current-patch
        set FIFO lput self FIFO
        set pcolor yellow

        if plabel = [plabel] of destination-patch [
          set pcolor green
        ]

      ]

    ]

  ]
  user-message( "A path from the source to the destination does not exist." )
  report path-to-destination

end

to DFS [source-patch destination-patch]
  clear-view source-patch destination-patch
  set LIFO []
  set LIFO lput one-of patches with [plabel = source-patch] LIFO

  ask one-of turtles
  [
    set path run-DFS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
  ]
  wait 1
  ask patches with[pcolor = yellow or pcolor = brown]
  [
    set pcolor blue + 3
  ]

  move source-patch destination-patch
end

to-report run-DFS [source-patch destination-patch]
  let DFSpath []
  let path-to-destination []
  let temp []
  ask first LIFO [
    set parent-patch first LIFO
  ]
  while [not empty? LIFO] [
    let current-patch first LIFO

    set LIFO remove-item 0 LIFO

    if not member? current-patch DFSpath[
      set DFSpath lput current-patch DFSpath
    ]
    if [plabel] of current-patch = [plabel] of destination-patch
    [
      set current-patch [parent-patch] of current-patch
      while [current-patch != [parent-patch] of current-patch] [
        set path-to-destination fput current-patch path-to-destination
        ask current-patch[
          set pcolor 26
        ]
        set current-patch [parent-patch] of current-patch

      ]
      report path-to-destination
    ]
    ask current-patch[
      set pcolor brown
      if plabel = [plabel] of source-patch [
        set pcolor magenta
      ]
      ask neighbors4 with [pcolor != white and not member? self DFSpath and pxcor >= min-pxcor and pycor >= min-pycor and pxcor <= max-pxcor and pycor <= max-pycor ][
        set parent-patch current-patch
        set LIFO fput self LIFO
        set pcolor yellow
        if plabel = [plabel] of destination-patch [
          set pcolor green
        ]
      ]


    ]

  ]
  user-message( "A path from the source to the destination does not exist." )
  report path-to-destination

end

to UCS [source-patch destination-patch]
  clear-view source-patch destination-patch
  ask one-of turtles
  [
    set path run-UCS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
  ]
  wait 1
  ask patches with[pcolor = yellow or pcolor = brown]
  [
    set pcolor blue + 3
  ]
  move source-patch destination-patch
end

to-report run-UCS [ source-patch destination-patch]

  let search-done? false
  let search-path []
  let current-patch 0
  set open []
  set closed []
  ask source-patch[
  ]


  set open lput source-patch open

  while [ search-done? != true]
  [
    ifelse length open != 0
    [
      set open sort-by [[?1 ?2 ] -> [g] of ?1 < [g] of ?2] open

      set current-patch item 0 open
      set open remove-item 0 open

      set closed lput current-patch closed

      ask current-patch
      [
        ifelse any? neighbors4 with [ (pxcor = [ pxcor ] of destination-patch) and (pycor = [pycor] of destination-patch)]
        [
          set search-done? true
        ]
        [
          ask neighbors4 with [ pcolor != white and (not member? self closed) and (self != parent-patch) ]
          [
            if not member? self open and self != source-patch and self != destination-patch
            [
              set pcolor 45
              set open lput self open
              set parent-patch current-patch
              set g[g] of parent-patch + random 10
            ]
          ]
        ]
        if self != source-patch
        [
          set pcolor 35
        ]
      ]
    ]
    [
      user-message( "A path from the source to the destination does not exist." )
      report []
    ]
  ]

  set search-path lput current-patch search-path
  let temp first search-path
  while [ temp != source-patch ]
  [
    ask temp
    [
      set pcolor 26
    ]
    set search-path lput [parent-patch] of temp search-path
    set temp [parent-patch] of temp
  ]

  set search-path fput destination-patch search-path

  set search-path reverse search-path

  report search-path
end

to A* [source-patch destination-patch]
  clear-view source-patch destination-patch
  ask one-of turtles
  [
    set path run-A* one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
  ]
  wait 1
  ask patches with[pcolor = yellow or pcolor = brown]
  [
    set pcolor blue + 3
  ]
  move source-patch destination-patch
end

to-report run-A* [source-patch destination-patch]

  let search-done? false
  let search-path []
  let current-patch 0
  set open []
  set closed []

  set open lput source-patch open

  while [ search-done? != true]
  [
    ifelse length open != 0
    [
      set open sort-by [[?1 ?2 ] -> [f] of ?1 < [f] of ?2] open

      set current-patch item 0 open
      set open remove-item 0 open

      set closed lput current-patch closed

      ask current-patch
      [
        ifelse any? neighbors4 with [ (pxcor = [ pxcor ] of destination-patch) and (pycor = [pycor] of destination-patch)]
        [
          set search-done? true
        ]
        [
          ask neighbors4 with [ pcolor != white and (not member? self closed) and (self != parent-patch) ]
          [
            if not member? self open and self != source-patch and self != destination-patch
            [
              set pcolor 45
              set open lput self open
              set parent-patch current-patch
              set g [g] of parent-patch  + 1
              set h distance destination-patch
              set f (g + h)
            ]
          ]
        ]
        if self != source-patch
        [
          set pcolor 35
        ]
      ]
    ]
    [
      user-message( "A path from the source to the destination does not exist." )
      report []
    ]
  ]

  set search-path lput current-patch search-path
  let temp first search-path
  while [ temp != source-patch ]
  [
    ask temp
    [
      set pcolor 26
    ]
    set search-path lput [parent-patch] of temp search-path
    set temp [parent-patch] of temp
  ]

  set search-path fput destination-patch search-path

  set search-path reverse search-path

  report search-path
end

to reverse-path
  ask patches with [plabel = "source"][
    set plabel "temp"
  ]

  ask patches with [plabel = "destination"][
    set plabel "source"
  ]

 ask patches with [plabel = "temp"][
    set plabel "destination"
  ]

end

to run-level
  if Levels = "level 1" [
    if Algorithm = "A*" [A* "source" "destination"]
    if Algorithm = "BFS" [BFS  "source" "destination"]
    if Algorithm = "DFS" [DFS  "source" "destination"]
    if Algorithm = "UCS" [UCS  "source" "destination"]

  ]
  if Levels = "level 2" [

    let temp (random 4)
    if temp = 0 [ set Algorithm "A*" A* "source" "destination" ]
    if temp = 1 [ set Algorithm "BFS" BFS "source" "destination" ]
    if temp = 2 [ set Algorithm "DFS" DFS "source" "destination" ]
    if temp = 3 [ set Algorithm "UCS" UCS "source" "destination" ]
    wait 1
    let temp2 random 4
    while [temp2 = temp] [
      set temp2 (random 4)
    ]
    reverse-path
    if temp2 = 0 [ set Algorithm "A*" A* "source" "destination" ]
    if temp2 = 1 [ set Algorithm "BFS" BFS"source" "destination" ]
    if temp2 = 2 [ set Algorithm "DFS" DFS "source" "destination" ]
    if temp2 = 3 [ set Algorithm "UCS" UCS "source" "destination" ]
    reverse-path
  ]
  if Levels = "level 3" [
    let index 1
    while [index <= number_of_agents][
      let temp (random 4)
      ask patches with [plabel = index][
        set pcolor magenta
      ]
      if temp = 0 [ set Algorithm "A*" A* index "destination" ]
      if temp = 1 [ set Algorithm "BFS" BFS index "destination" ]
      if temp = 2 [ set Algorithm "DFS" DFS index "destination" ]
      if temp = 3 [ set Algorithm "UCS" UCS index "destination" ]
      clear-view index "destination"
      set index index + 1
      wait 1
    ]
  ]
end


to reset
  if Levels = "level 1" [
    clear-view "source" "destination"

  ]
  if Levels = "level 2" [
    clear-view "source" "destination"

  ]
  if Levels = "level 3" [
    let index 1
    while [index <= number_of_agents][
      clear-view index "destination"
      set index index + 1
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
593
20
1363
791
-1
-1
18.6
1
10
1
1
1
0
0
0
1
-20
20
-20
20
0
0
1
ticks
30.0

CHOOSER
13
26
152
71
icon
icon
"turtle" "person" "box" "car" "cow" "wolf" "triangle" "truck" "star"
0

BUTTON
172
28
281
61
Set up
set-up\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
13
95
153
140
Select-element
Select-element
"obstacles" "erase obstacles" "source" "destination"
3

BUTTON
174
97
280
135
EDIT
draw-maze\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
270
209
420
227
NIL
11
0.0
1

BUTTON
271
260
384
309
LOAD MAP
load-maze\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
16
174
256
234
name_file_save
level_1.png
1
0
String

BUTTON
272
181
382
233
SAVE MAP
save-maze
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
16
251
255
311
name_file_load
level_1.png
1
0
String

CHOOSER
1390
27
1595
72
Levels
Levels
"level 1" "level 2" "level 3"
2

CHOOSER
1391
93
1594
138
Algorithm
Algorithm
"A*" "BFS" "DFS" "UCS"
2

BUTTON
1393
169
1598
235
RUN
run-level\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
17
339
233
372
Number_of_agents
Number_of_agents
1
50
5.0
1
1
NIL
HORIZONTAL

BUTTON
305
29
406
62
Reset
reset
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
