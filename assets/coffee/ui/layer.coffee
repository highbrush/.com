###*
 * Controls the layers
###
app.add 'layer',
  init: ->
    # Load store
    setTimeout ->
      layers = app.getStore('layers').getAll()
      _.each layers, (layer) ->
        paper.project.importJSON layer
