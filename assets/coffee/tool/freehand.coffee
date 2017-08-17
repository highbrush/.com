app.addTool 'freehand',
  default: true

  onMouseDown: (event) ->
    @path = new Path()
    @path.strokeColor = 'black'
    @path.strokeWidth = 3
    @path.add event.point

  onMouseDrag: (event) ->
    @path.add event.point
