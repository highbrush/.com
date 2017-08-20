###*
 * Basic freehand tool
###
app.addTool 'oz.freehand.og',
  default: true

  css:
    background: '#333'

  paths: []

  ###*
   * Create a new path for each finger
  ###
  onTouchStart: (event) ->
    paths = @paths
    _.each event.changedTouches, (touch) ->
      path = new paper.Path()
      path.strokeColor = app.util.getRandomColor()
      path.strokeWidth = _.random 2, 25
      paths[touch.identifier] = path
    @paths = paths

  ###*
   * Draw the paths, strobing them as we go
  ###
  onTouchMove: (event) ->
    paths = @paths
    _.each event.changedTouches, (touch) ->
      id = touch.identifier
      paths[id].strokeColor = app.util.getRandomColor()
      paths[id].add(new Point(touch.pageX + app.util.getCenterX(), touch.pageY + app.util.getCenterY()))

  ###*
   * Save the paths
  ###
  onTouchEnd: (event) ->
    app.getStore('layers').setItem 1, paper.project.exportJSON()
