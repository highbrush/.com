###*
 * Controller for brushes
###
app.add 'ui.brush',
  init: () ->
    $('[data-brush-id]').each ->
      $brush = $ this

      # Make it draggable
      $brush.pep
        constrainTo: 'window'
        useCSSTranslation: false
        rest: ->
          app.getStore('brushes').setItem @$el.data('brush-id'),
            left: @$el.offset().left
            top: @$el.offset().top

      # Set the offset
      offset = app.getStore('brushes').getItem $brush.data('brush-id')
      if !_.isEmpty offset then $brush.offset offset

      $brush.removeClass 'hidden'
