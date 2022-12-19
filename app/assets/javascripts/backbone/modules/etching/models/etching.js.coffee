@BG.module "Etching", (Etching, App) ->

  class Etching.EtchingModel extends Backbone.Model
    url: "/show/:id"

    sanitized: () ->
      decodeURIComponent(@get('title'))
        .toLowerCase()
        .replace(/\s/g, '_')

    printUrl: (index=0) ->
      '/med/' + @sanitized() + '_med.jpg'

    largePrintUrl: (index=0) ->
      i = if index then '_' + (index + 1) else ''
      '/large/' + @sanitized() + i + '.jpg'

    backgroundImageUrl: (url) ->
      ['url("', url, '")'].join('')

    randomPrint: ->
      _.sample(@get('prints'))

    randomPrintIndex: ->
      _.random(0, @get('prints').length - 1)
