###*
 * Exposes public methods and adds canvas listeners
###
paper.install window
app =
  init: ->
    # Setup libs
    paper.setup 'canvas'
    @touch = touch = new Hammer $('#canvas')[0]
    @touch.get('pan').set
      direction: Hammer.DIRECTION_ALL
      threshold: 0

    # Setup listeners
    _.each @._.events, (event) ->
      touch.on _.toLower(event), (touchEvent) ->
        ctrl = app.getTool()
        if ctrl["on#{event}"] then ctrl["on#{event}"].apply ctrl, arguments

    # Temp stuff
    path = new paper.Path()
    path.strokeColor = 'black'
    start = new paper.Point(100, 100)
    path.moveTo(start)
    path.lineTo(start.add([ 200, -50 ]))
    paper.view.draw()

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
        init: ->
      _.set app._, "tool.#{id}", config
      tool = app.getTool id

      # Create the ui
      $tool = $('<div />',
        'class': 'highbrush-tool animate-jelly-in'
        'data-brush-id': id).appendTo 'body'

      # Add drag effects
      $tool.pep
        constrainTo: 'window'
        useCSSTranslation: false
        rest: ->
          app.getStore('brushes').setItem @$el.data('brush-id'),
            left: @$el.offset().left
            top: @$el.offset().top

      # Set initial position
      $body = $ 'body'
      offset = app.getStore('brushes').getItem $tool.data('brush-id')
      if !offset or _.isEmpty offset
        offset =
          top: ($body.height() - $tool.height()) * Math.random() + $tool.height()
          left: ($body.width() - $tool.width()) * Math.random() + $tool.width()
      offset.left = Math.min offset.left, $body.width() - $tool.width()
      offset.top = Math.min offset.top, $body.height() - $tool.height()
      $tool.offset offset

      # Apply styles
      if config.css then $tool.css config.css

      # Click events
      $tool.on 'click touchstart', ->
        app.setTool id
        app.getStore('canvas').setItem 'brush', id

      # Attach shortcuts
      _.each config.shortcuts, (callback, shortcut) ->
        if _.isString callback
          callback = config.shortcuts[shortcut] = tool[callback]
        Mousetrap.bind shortcut, callback

      # Activate the tool and fire init
      lastBrush = app.getStore('canvas').getItem 'brush'
      if (config.default && !lastBrush) || lastBrush == id then app.setTool id
      tool.init()

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
    events: [
      'Pan'
      'PanStart'
      'PanMove'
      'PanEnd'
      'PanCancel'
      'PanLeft'
      'PanRight'
      'PanUp'
      'PanDown'
      'Pinch'
      'PinchStart'
      'PinchMove'
      'PinchEnd'
      'PinchCancel'
      'PinchIn'
      'PinchOut'
      'Press'
      'PressUp'
      'Rotate'
      'RotateStart'
      'RotateMove'
      'RotateEnd'
      'RotateCancel'
      'Swipe'
      'SwipeLeft'
      'SwipeRight'
      'SwipeUp'
      'SwipeDown'
      'Tap'
    ]

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
