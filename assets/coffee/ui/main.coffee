###*
 * Controls the main ui
###
app.add 'ui.main',
  init: () ->
    $('.highbrush').pep
      constrainTo: 'window'
      useCSSTranslation: false
      stop: ->
        localStorage
