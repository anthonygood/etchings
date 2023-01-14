@BG.module "Etching.Show", (Show, App) ->

  class Show.ShowView extends Marionette.LayoutView
    template: "etching/show/templates/show"
    regions:
      preview:    "#preview"
      navigation: "#navigation"

    onShow: ->
      $(document).scrollTop(0)

      prints = new Backbone.Collection @model.get('prints').map((title, i) =>
        title: title
        medium_url: @model.printUrl(i)
        index: i
      )

      @navigation.show new Show.NavigationView(model: @model)
      @preview.show new Show.Preview
                                  model: @model
                                  large_url: @model.largePrintUrl()
                                  collection: prints
                                  childView: Show.ThumbnailView
                                  orientation: @model.orientation()
