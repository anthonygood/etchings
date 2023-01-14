@BG.module "About", (About, App) ->

  class About.Router extends Marionette.AppRouter
    appRoutes:
      "about": "about"

  class About.Controller extends Marionette.Controller
    about: ->
      ids = _(App.Data.etchings.filter(
        (etching) => etching.get('themes').includes("The Artist Himself"))
      ).pluck('id')
      portraits = new App.Etching.EtchingCollection App.Data.etchings.fetchWithIds(ids)

      App.headerRegion.empty()
      App.mainRegion.show new About.View
        collection: portraits

  About.addInitializer ->
    new About.Router controller: new About.Controller()
