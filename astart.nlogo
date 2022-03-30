; global variables used
globals 
[  
  open ; the open list of patches
  closed ; the closed list of patches
  optimal-path ; the optimal path, list of patches from source to destination
]

; patch variables used
patches-own 
[ 
  parent-patch ; patch's predecessor
  f ; the value of knowledge plus heuristic cost function f()
  g ; the value of knowledge cost function g()
  h ; the value of heuristic cost function h()
]

; turtle variables used
turtles-own
[
  path ; the optimal path from source to destination
  current-path ; part of the path that is left to be traversed 
]

; setup the world 
to Setup
  clear-all ;; clear everything (the view and all the variables)
  create-source-and-destination
end

; create the source and destination at two random locations on the view
to create-source-and-destination
  ask one-of patches with [pcolor = black]
  [ 
    set pcolor blue 
    set plabel "source"
    sprout 1 
    [ 
      set color red 
      pd
    ] 
  ]
  ask one-of patches with [pcolor = black]
  [ 
    set pcolor green 
    set plabel "destination"
  ]
end

; draw the selected maze elements on the view
to draw
  if mouse-inside?
    [
      ask patch mouse-xcor mouse-ycor
      [
        sprout 1
        [
          set shape "square"
          die
        ]        
      ]
      
      ;draw obstacles      
      if Select-element = "obstacles"
      [      
        if mouse-down?
        [         
          if [pcolor] of patch mouse-xcor mouse-ycor = black or [pcolor] of patch mouse-xcor mouse-ycor = brown or [pcolor] of patch mouse-xcor mouse-ycor = yellow
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
              set pcolor black
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
              set pcolor black
              set plabel ""
            ]
            ask turtles
            [
              die
            ]          
            ask patch m-xcor m-ycor
            [   
              set pcolor blue 
              set plabel "source"
              sprout 1 
              [ 
                set color red 
                pd
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
                  set pcolor black
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

; call the path finding procedure, update the turtle (agent) variables, output text box
; and make the agent move to the destination via the path found
to find-shortest-path-to-destination
  reset-ticks
  ask one-of turtles 
  [
    move-to one-of patches with [plabel = "source"]
    set path find-a-path one-of patches with [plabel = "source"] one-of patches with [plabel = "destination"]
    set optimal-path path
    set current-path path
  ]
  output-show (word "Shortest path length : " length optimal-path)
  move
end


; the actual implementation of the A* path finding algorithm
; it takes the source and destination patches as inputs
; and reports the optimal path if one exists between them as output
to-report find-a-path [ source-patch destination-patch] 
  
  ; initialize all variables to default values
  let search-done? false
  let search-path []
  let current-patch 0
  set open []
  set closed []  
  
  ; add source patch in the open list
  set open lput source-patch open
  
  ; loop until we reach the destination or the open list becomes empty
  while [ search-done? != true]
  [    
    ifelse length open != 0
    [
      ; sort the patches in open list in increasing order of their f() values
      set open sort-by [[f] of ?1 < [f] of ?2] open
      
      ; take the first patch in the open list
      ; as the current patch (which is currently being explored (n))
      ; and remove it from the open list
      set current-patch item 0 open 
      set open remove-item 0 open
      
      ; add the current patch to the closed list
      set closed lput current-patch closed
      
      ; explore the Von Neumann (left, right, top and bottom) neighbors of the current patch
      ask current-patch
      [         
        ; if any of the neighbors is the destination stop the search process
        ifelse any? neighbors4 with [ (pxcor = [ pxcor ] of destination-patch) and (pycor = [pycor] of destination-patch)]
        [
          set search-done? true
        ]
        [
          ; the neighbors should not be obstacles or already explored patches (part of the closed list)          
          ask neighbors4 with [ pcolor != white and (not member? self closed) and (self != parent-patch) ]     
          [
            ; the neighbors to be explored should also not be the source or 
            ; destination patches or already a part of the open list (unexplored patches list)
            if not member? self open and self != source-patch and self != destination-patch
            [
              set pcolor 45
              
              ; add the eligible patch to the open list
              set open lput self open
              
              ; update the path finding variables of the eligible patch
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
      ; if a path is not found (search is incomplete) and the open list is exhausted 
      ; display a user message and report an empty search path list.
      user-message( "A path from the source to the destination does not exist." )
      report []
    ]
  ]
  
  ; if a path is found (search completed) add the current patch 
  ; (node adjacent to the destination) to the search path.
  set search-path lput current-patch search-path
  
  ; trace the search path from the current patch 
  ; all the way to the source patch using the parent patch
  ; variable which was set during the search for every patch that was explored
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
  
  ; add the destination patch to the front of the search path
  set search-path fput destination-patch search-path
  
  ; reverse the search path so that it starts from a patch adjacent to the
  ; source patch and ends at the destination patch
  set search-path reverse search-path  

  ; report the search path
  report search-path
end

; make the turtle traverse (move through) the path all the way to the destination patch
to move
  ask one-of turtles 
  [
    while [length current-path != 0]
    [
      go-to-next-patch-in-current-path
      pd
      wait 0.05
    ]
    if length current-path = 0
    [
      pu
    ]
  ]   
end

to go-to-next-patch-in-current-path  
  face first current-path
  repeat 10
  [
    fd 0.1
  ]
  move-to first current-path
  if [plabel] of patch-here != "source" and  [plabel] of patch-here != "destination"
  [
    ask patch-here
    [
      set pcolor black
    ]
  ]
  set current-path remove-item 0 current-path
end

; clear the view of everything but the source and destination patches 
to clear-view
  cd
  ask patches with[ plabel != "source" and plabel != "destination" ]
  [
    set pcolor black
  ]
end

; load a maze from the file system
to load-maze [ maze ]  
  if maze != false
  [
    ifelse (item (length maze - 1) maze = "g" and item (length maze - 2) maze = "n" and item (length maze - 3) maze = "p" and item (length maze - 4) maze = ".")
    [
      save-maze "temp.png"
      clear-all
      import-pcolors maze  
      ifelse count patches with [pcolor = blue] = 1 and count patches with [pcolor = green] = 1
      [
        ask patches 
        [
          set plabel ""
        ]
        ask turtles
        [
          die
        ]    
        ask one-of patches with [pcolor = blue]
        [
          set plabel "source"
          sprout 1 
          [ 
            set color red 
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
        load-maze "temp.png"
        ;;clear-view
      ]
    ]
    [
      user-message "The selected file is not a valid image."
    ]
  ]
end

to save-maze [filename]
  if any? patches with [pcolor != black]
  [
    clear-unwanted-elements
    export-view (filename)
    restore-labels
  ]
end

to clear-unwanted-elements
  if any? patches with [pcolor = brown or pcolor = yellow  ]
  [
    ask patches with [pcolor = brown or pcolor = yellow  ]
    [
      set pcolor black
    ]
  ]
  if any? patches with [pcolor = blue]
  [
    ask one-of patches with [pcolor = blue]
    [
      set plabel ""
    ] 
  ]
  if any? patches with [pcolor = green]
  [
    ask one-of patches with [pcolor = green]
    [
      set plabel ""
    ] 
  ]
  clear-drawing
  ask turtles
  [
    die
  ]
end

to restore-labels
  ask one-of patches with [pcolor = blue]
  [
    set plabel "source"
    sprout 1 
    [ 
      set color red 
      pd
    ] 
  ] 
  ask one-of patches with [pcolor = green]
  [
    set plabel "destination"
  ] 
end
