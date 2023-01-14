@BG.module "Footer.Show", (Show, EtchingsApp) ->

  Show.Controller = 
    showFooterView: ->
      BG.footerRegion.show new @getFooterView()

    getFooterView: ->
      new Show.FooterView()
