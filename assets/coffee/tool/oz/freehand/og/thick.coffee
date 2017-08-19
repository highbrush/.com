###*
 * Basic freehand tool
###
app.addTool 'oz.freehand.og.thick',
  css:
    background: '#333'

  ###*
   * Create a new random stroke
  ###
  onMouseDown: (event) ->
    @path = new Path()
    @path.strokeColor = '#'+Math.floor(Math.random()*16777215).toString(16);
    @path.strokeWidth = Math.min 40, 40 + _.random(0, 5) * 5
    @path.add event.point

  ###*
   * Strobe the color as we draw
  ###
  onMouseDrag: (event) ->
    @path.strokeColor = '#'+Math.floor(Math.random()*16777215).toString(16);
    @path.add event.point

  ###*
   * Save
  ###
  onMouseUp: (event) ->
    app.getStore('layers').setItem 1, paper.project.exportJSON()
