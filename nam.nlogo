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
]

to set-up
  clear-all
  create-source-and-destination
end

to create-source-and-destination
  if Levels = "level 1"[
  ask patches [set pcolor  blue + 2]
    ask one-of patches with [pcolor =  blue + 2]
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
    
    
    
    ask one-of patches with [pcolor =  blue + 2]
    [
      set pcolor green
      set plabel "destination"
    ]
  ]
  
  if Levels = "level 2"[
    ask patches [set pcolor  blue + 2]
    ask one-of patches with [pcolor =  blue + 2]
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
    
    
    
    ask one-of patches with [pcolor =  blue + 2]
    [
      set pcolor green
      set plabel "destination 1"
    ]
    
    ask one-of patches with [pcolor =  blue + 2 and plabel != "destination 1"]
    [
      set pcolor green
      set plabel "destination 2"
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
          if [pcolor] of patch mouse-xcor mouse-ycor = blue + 2 or [pcolor] of patch mouse-xcor mouse-ycor = brown or [pcolor] of patch mouse-xcor mouse-ycor = yellow
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
              set pcolor blue + 2
            ]
          ]
        ]
      ]

      ;draw source patch
      if Select-element = "source"
      [
        if mouse-down?
        [
          let m-xcor mouse-xcor
          let m-ycor mouse-ycor
          if [plabel] of patch m-xcor m-ycor != "destination"
          [
            ask patches with [plabel = "source"]
            [
              set pcolor blue + 2
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
                  set pcolor blue + 2
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

to clear-view 
  cd
  ask patches with[pcolor = yellow or pcolor = brown or pcolor = black or pcolor = cyan]
  [
    set pcolor blue + 2
  ]

  ask patches with[ plabel = "destination" ] [
    ask turtles with [color = red] [die]
    set pcolor green
  ]
  ask patches with[ plabel = "destination 1" ] [
    ask turtles with [color = red] [die]
    set pcolor green
  ]
  ask patches with[ plabel = "destination 2" ] [
    ask turtles with [color = red] [die]
    set pcolor green
  ]

  ask one-of patches with [plabel = "source" ]
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
end

to A* [source-patch destination-patch]
  clear-view
  ask one-of turtles
  [
    set path run-A* one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
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
      set pcolor 85
    ]
    set search-path lput [parent-patch] of temp search-path
    set temp [parent-patch] of temp
  ]

  set search-path fput destination-patch search-path

  set search-path reverse search-path

  report search-path
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
      ifelse count patches with [pcolor = magenta] = 1 and count patches with [pcolor = green] = 1
      [
        ask patches
        [
          set plabel ""
        ]
        ask turtles
        [
          die
        ]
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
      set pcolor blue + 2
    ]
  ]
  if any? patches with [plabel ="source"]
  [
    ask one-of patches with [plabel ="source"]
    [
      set pcolor magenta
    ]
  ]
  if any? patches with [plabel ="destination"]
  [
    ask one-of patches with [plabel ="destination"]
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
  clear-view
  set FIFO []
  set FIFO lput one-of patches with [plabel = source-patch] FIFO

  ask one-of turtles
  [
    set path run-BFS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
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
          set pcolor cyan
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
  clear-view
  set LIFO []
  set LIFO lput one-of patches with [plabel = source-patch] LIFO

  ask one-of turtles
  [
    set path run-DFS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
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
          set pcolor cyan
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
  clear-view
  ask one-of turtles
  [
    set path run-UCS one-of patches with [plabel = source-patch] one-of patches with [plabel = destination-patch]
    set optimal-path path
    set current-path path
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
      set pcolor 85
    ]
    set search-path lput [parent-patch] of temp search-path
    set temp [parent-patch] of temp
  ]

  set search-path fput destination-patch search-path

  set search-path reverse search-path

  report search-path
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
    if temp = 0 [A* "source" "destination 1"]
    if temp = 1 [BFS"source" "destination 1"]
    if temp = 2 [DFS "source" "destination 1"]
    if temp = 3 [UCS "source" "destination 1"]
    wait 0.5
    set temp (random 4)
    if temp = 0 [A* "destination 1" "destination 2"]
    if temp = 1 [BFS "destination 1" "destination 2"]
    if temp = 2 [DFS "destination 1" "destination 2"]
    if temp = 3 [UCS "destination 1" "destination 2"]
  ]
  if Levels = "level 3" []
end 