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

  onPanStart: (event) ->
    @origX = paper.view.center.x
    @origY = paper.view.center.y


  ###*
   * Panning
  ###
  onPanMove: (event) ->
    delta =
      x: @origX - event.deltaX
      y: @origY - event.deltaY
    paper.view.center = delta

  ###*
   * Save view position
  ###
  onPanEnd: (event) ->
    app.getStore('canvas').setItem 'center', _.pick(paper.view.center, ['x', 'y'])

  ###*
   * Rotate the view
  ###
  onRotate: (event) ->
    console.log 'onRotate', event

  ###*
   * Clear the project
  ###
  clear: ->
    paper.project.clear()
    app.getStore('layers').removeAll()
