###*
 * Exposes public methods and adds canvas listeners
###
app =
  init:
    paper.install window

  ###*
   * Adds a new tool, and activates it
   * @param {STRING} id     The unique id for this tool
   * @param {OBJECT} config The config object
  ###
  addTool: (id, config) ->
    $ ->
      # Setup properties
      tool = new Tool()
      _.set config, '_.id', id
      _.set config, '_.tool', tool
      _.set app._, "tool['#{id}']", config

      # Activate the tool
      if config.default then app.setTool id

  ###*
   * Returns a tool controller (or the active one if nothing is passed)
   * @param  {STRING|NULL} id The id of the tool to retreive, or null for current one
   * @return {OBJECT}    The tool controller
  ###
  getTool: (id) ->
    if !id then id = 'active'
    _.get app._, "tool['#{id}']"

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

$ -> app.init
