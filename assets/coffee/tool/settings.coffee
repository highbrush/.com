###*
 * Global settings tool
 * - Pan
 * - Zoom
###
app.addTool 'settings',
  shortcuts:
    space: 'clear'

  styles: """
    #settings-interaction {
      position: fixed;
      margin-left: -50000px;
      margin-top: -50000px;
      width: 100000px;
      height: 100000px;
    }
  """

  # Used to position the view
  orig:
    mask:
      x: -50000
      y: -50000
    view:
      x: -50000
      y: -50000

  ###*
   * Load the initial view position
  ###
  init: ->
    center = app.getStore('canvas').getItem 'center'
    center = _.defaults center,
      x: -50000
      y: -50000
    paper.view.center = center

  ###*
   * Create a draggable mask for kinetic effects, and transfer values to paper.view
  ###
  onActivate: ->
    ctrl = this

    if !@mask
      @mask = $('<div />', {
        id: 'settings-interaction'
      }).prependTo('body')
      @mask.pep
        start: ->
          ctrl.orig =
            mask:
              x: ctrl.mask.offset().left
              y: ctrl.mask.offset().top
            view:
              x: paper.view.center.x
              y: paper.view.center.y
        drag: -> ctrl.updateView.call ctrl
        easing: -> ctrl.updateView.call ctrl
        stop: -> ctrl.saveView.call ctrl
        rest: -> ctrl.saveView.call ctrl

    @mask.show()
    @mask.css
      left: -50000
      top: -50000
      pointerEvents: 'auto'

  ###*
   * Translates the mask position to the view
  ###
  updateView: ->
    paper.view.center =
      x: @orig.view.x + @orig.mask.x - @mask.offset().left
      y: @orig.view.y + @orig.mask.y - @mask.offset().top

  ###*
   * Saves the view position
  ###
  saveView: ->
    app.getStore('canvas').setItem 'center', _.pick(paper.view.center, ['x', 'y'])

  ###*
   * Removes the mask
  ###
  onDeactivate: ->
    @mask.css pointerEvents: 'none'

  # Clear the project
  clear: ->
    paper.project.clear()
    app.getStore('layers').removeAll()
