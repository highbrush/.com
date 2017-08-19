###*
 * Basic freehand tool
###
app.addTool 'oz.freehand.og',
  default: true

  css:
    background: '#333'

  onTouchStart: (event) ->
    console.log 'onTouchStart', event
  onTouchMove: (event) ->
    console.log 'onTouchMove', event
  onTouchEnd: (event) ->
    console.log 'onTouchEnd', event

  ###*
   * Create a new random stroke
  ###
  onMouseDown: (event) ->
    @path = new Path()
    @path.strokeColor = app.util.getRandomColor()
    @path.strokeWidth = Math.max 2, _.random(0, 7)
    @path.add event.point

  ###*
   * Strobe the color as we draw
  ###
  onMouseDrag: (event) ->
    @path.strokeColor = app.util.getRandomColor()
    @path.add event.point

  ###*
   * Save
  ###
  onMouseUp: (event) ->
    app.getStore('layers').setItem 1, paper.project.exportJSON()
