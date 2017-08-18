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
      _.set config, 'shortcut', {}
      config = _.defaults config,
        onMouseDown: ->
        onMouseDrag: ->
        onMouseUp: ->
      _.set app._, "tool.#{id}", config

      # Create the ui
      $tool = $('<div />',
        'class': 'highbrush-tool animate-jelly-in'
        'data-brush-id': id).appendTo 'body'
      $tool.pep
        constrainTo: 'window'
        useCSSTranslation: false
        rest: ->
          app.getStore('brushes').setItem @$el.data('brush-id'),
            left: @$el.offset().left
            top: @$el.offset().top
      offset = app.getStore('brushes').getItem $tool.data('brush-id')
      if !_.isEmpty offset then $tool.offset offset

      # Attach shortcuts
      _.each config.shortcuts, (callback, shortcut) ->
        if _.isString callback
          callback = config.shortcuts[shortcut] = app.getTool(id)[callback]
        Mousetrap.bind shortcut, callback

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
   * Adds a new store, and activates it
   * @param {STRING} id     The unique id for this store
   * @param {OBJECT} config The config object
  ###
  addStore: (id, config = {}) ->
    # Setup properties
    _.set config, '_.id', id
    _.set app._, "store.#{id}", config
    _.defaults config, app._.store.base

    # Autoload data
    app.getStore(id).initCache()

  ###*
   * Returns a store
   * @param  {STRING|NULL} id The id of the store to retreive
   * @return {OBJECT}    The store
  ###
  getStore: (id) ->
    _.get app._, "store.#{id}"

  ###*
   * Private shit, you probably shouldn't mess with this
  ###
  _:
    tool:
      active: ''
    store:
      ###*
       * Defines the base store class
      ###
      base:
        ###*
         * Stores a cached copy of the store
        ###
        cached: {}

        ###*
         * Initializes the cache. Requires a store property with the key to load
        ###
        initCache: () ->
          @cached = JSON.parse(localStorage.getItem(@_.id)) or {}
          return @cached

        ###*
         * Gets a cached record
         * @param {STR} key The record to get (by key)
        ###
        getCached: (key) ->
          return @cached[key]

        ###*
         * Updates the store with whatever is in the cache
        ###
        saveCached: () ->
          localStorage.setItem @_.id, JSON.stringify @cached
          return

        ###*
         * Sets a cached record
         * @param {STR} key   The record to get (by key)
         * @param {ANY} value The value to store
         * @return {ANY} The stored value
        ###
        setCached: (key, value) ->
          @cached[key] = value
          record = {}
          record[key] = value
          @saveCached()
          return record

        ###*
         * Gets a record
         * @param {STR} key The record to get (by key)
         * @param {ANY} defVal The default value
        ###
        getItem: (key, defVal) ->
          val = @getCached key
          return if _.isUndefined val then defVal else  val

        ###*
         * Stores an item to Firebase (and locally)
         * @param {STR} key   The record to get (by key)
         * @param {ANY} value The value to store
         * @return {ANY} The stored value
        ###
        setItem: (key, value) ->
          return @setCached key, value

        ###*
         * Removes the record with key
         * @param  {STR/ARR} keys The key(s) to remove
        ###
        removeItem: (keys) ->
          ctrl = this
          if _.isString keys
            keys = [keys]

          _.each keys, (key) ->
            delete ctrl.cached[key]
            return

        ###*
         * Removes all the records
        ###
        getAll: () ->
          JSON.parse localStorage.getItem @_.id

        ###*
         * Removes all the records
        ###
        removeAll: () ->
          localStorage.removeItem @_.id
          @cached = {}

$ ->
  app.init()
