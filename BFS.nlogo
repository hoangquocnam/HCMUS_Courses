to BFS
  set FIFO lput one-of patches with [plabel = "source"]
  run-BFS
end

to-report run-BFS
  let path []
  while FIFO not empty[
    let current-patch first FIFO
    set FIFO remove-item 0 FIFO

    if not member? current-patch path[
      set path lput current-patch
    ]
    ask current-patch[
      ask neighbors4 with [pcolor != white and not member? self path][
        set FIFO lput self FIFO
      ]
      
    ]
      
  ]

  report path
end
