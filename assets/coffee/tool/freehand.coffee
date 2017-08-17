###*
 * Basic freehand tool
###
app.addTool 'freehand',
  default: true

  shortcuts:
    'space': 'clear'

  ###*
   * Create a new random stroke
  ###
  onMouseDown: (event) ->
    @path = new Path()
    @path.strokeColor = '#'+Math.floor(Math.random()*16777215).toString(16);
    @path.strokeWidth = _.random 1, 100
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

  ###*
   * Clear the project
  ###
  clear: ->
    paper.project.clear()
    app.getStore('layers').removeAll()
