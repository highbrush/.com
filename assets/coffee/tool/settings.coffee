###*
 * Global settings tool
 * - Pan
 * - Zoom
 * - Rotate
###
app.addTool 'settings',
  shortcuts:
    space: 'clear'

  init: ->
    center = app.getStore('canvas').getItem 'center'
    center = _.defaults center,
      x: 0
      y: 0
    paper.view.center = center

  ###*
   * Panning
  ###
  onMouseDrag: (event) ->
    delta =
      x: paper.view.center.x + event.downPoint.x - event.point.x
      y: paper.view.center.y + event.downPoint.y - event.point.y

    paper.view.center = delta

  ###*
   * Save view position
  ###
  onMouseUp: (event) ->
    app.getStore('canvas').setItem 'center', _.pick(paper.view.center, ['x', 'y'])

  ###*
   * Clear the project
  ###
  clear: ->
    paper.project.clear()
    app.getStore('layers').removeAll()
