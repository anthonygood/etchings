@BG.module "Inquiry", (Inquiry, App) ->
  class Inquiry.InquiryRouter extends Marionette.AppRouter
    # appRoutes:
    #   "buy(/:id)": "buy"
    #   "inquire"  : "inquire"
    #   "enquire"  : "inquire"

  class Inquiry.InquiryController extends Marionette.Controller
    initialize: ->
      @listenTo App.vent, "inquiry:success", @thankYou
      @listenTo App.vent, "navigation:back", @back

    buy: (id) ->
      return Backbone.history.navigate('/inquire', trigger: true) unless id
      etching = App.Data.etchings.get(id)
      inquiry = new Inquiry.InquiryModel(etching_id: id)
      App.headerRegion.empty()
      App.mainRegion.show new Inquiry.InquiryView model: inquiry

    inquire: ->
      inquiry = new Inquiry.InquiryModel()
      App.headerRegion.empty()
      App.mainRegion.show new Inquiry.InquiryView model: inquiry

    thankYou: ->
      App.headerRegion.empty()
      App.mainRegion.show new Inquiry.ThanksView()

    back: ->
      Backbone.history.history.back()

  Inquiry.addInitializer ->
    new Inquiry.InquiryRouter controller: new Inquiry.InquiryController()
