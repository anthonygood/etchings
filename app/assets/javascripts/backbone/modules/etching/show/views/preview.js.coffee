@BG.module "Etching.Show", (Show, App) ->

  class Show.Preview extends Marionette.CompositeView
    template: "etching/show/templates/preview"
    className: "preview"
    childViewContainer: ".thumbnails"
    collectionEvents:
      "thumbnail:select": "embiggenThumbnail"
    templateHelpers: () =>
      orientation: @model.orientation()
      large_url: @model.largePrintUrl(@index)

    onShow: ->
      @index = 0
      @lock = new Show.Lock(@$('.medium'), @options.orientation)
      @$(".thumbnails").hide() unless @collection.length > 1

    onRender: ->
      @lock.applyLock(@$('.medium')) if @lock
      # show loading colours unless image is cached
      view = @
      @$('.medium').each (thing) ->
        if @.complete
          view.$el.addClass "loaded"
        else
          $(@).on 'load', -> view.$el.addClass "loaded"

    embiggenThumbnail: (model) ->
      @index = model.get('index')
      @$el.removeClass('loaded')
      @render()
