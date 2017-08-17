###*
 * Exposes public methods and adds canvas listeners
###
paper.install window
app =
  ###*
   * Setup listeners
  ###
  init: ->
    paper.setup 'canvas'

    # Setup Tools
    tool = new Tool()
    tool.onMouseDown = ->
      ctrl = app.getTool()
      ctrl.onMouseDown.apply ctrl, arguments
    tool.onMouseUp = ->
      ctrl = app.getTool()
      ctrl.onMouseUp.apply ctrl, arguments
    tool.onMouseDrag = ->
      ctrl = app.getTool()
      ctrl.onMouseDrag.apply ctrl, arguments

  ###*
   * Defines a new observer object. Observers are just generic, global controllers with some happy bennies
   * @param {STRING} id     The unique id for this tool
   * @param {OBJECT} config The config object
  ###
  add: (id, config) ->
    $ ->
      # Setup properties
      _.set config, '_.id', id
      _.defaults config,
        init: ->
      _.set app._, "controller.#{id}", config

      # Run init
      app.get(id).init()

  ###*
   * Returns a controller by id
   * @param  {STRING|NULL} id The id of the controller to retreive
   * @return {OBJECT}    The tool controller
  ###
  get: (id) ->
    _.get app._, "controller.#{id}"

  ###*
   * Adds a new tool, and activates it
   * @param {STRING} id     The unique id for this tool
   * @param {OBJECT} config The config object
  ###
  addTool: (id, config) ->
    $ ->
      # Setup properties
      _.set config, '_.id', id
      _.set app._, "tool.#{id}", config
      config = _.defaults config,
        onMouseDown: ->
        onMouseDrag: ->
        onMouseUp: ->

      # Activate the tool
      if config.default then app.setTool id

  ###*
   * Returns a tool controller (or the active one if nothing is passed)
   * @param  {STRING|NULL} id The id of the tool to retreive, or null for current one
   * @return {OBJECT}    The tool controller
  ###
  getTool: (id) ->
    if !id then id = 'active'
    _.get app._, "tool.#{id}"

  ###*
   * Sets the current active tool
   * @param  {STRING} id The id of the tool to activate
   * @return {OBJECT} The tool controller
  ###
  setTool: (id) ->
    app._.tool.active = app.getTool id

  ###*
   * Private shit, you probably shouldn't mess with this
  ###
  _:
    tool:
      active: ''

$ ->
  app.init()
