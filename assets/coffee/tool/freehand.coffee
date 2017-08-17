###*
 * Basic freehand tool
###
app.addTool 'freehand',
  default: true

  onMouseDown: (event) ->
    @path = new Path()
    @path.strokeColor = '#'+Math.floor(Math.random()*16777215).toString(16);
    @path.strokeWidth = _.random 1, 100, true
    @path.add event.point

  onMouseDrag: (event) ->
    @path.strokeColor = '#'+Math.floor(Math.random()*16777215).toString(16);
    @path.add event.point

  onMouseUp: (event) ->
    app.getStore('layers').setItem 1, paper.project.exportJSON()
