Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  trackPageView: true

Router.route "/",
  template: "home"
  name: "home"

Router.route "/secret-link/:secretUrl",
  template: "game"
  name: "game"
  waitOn: ->
    return Meteor.subscribe "thisFleet", @.params.secretUrl
  data: ->
    targetFleet = Fleets.findOne {secretUrl: @.params.secretUrl}
    if targetFleet
      Session.set "fleet", targetFleet
      Session.setDefault "view", "area"
      Session.setDefault "debug", "false"
      Game.fleet = targetFleet
      Meteor.subscribe "nearbyStuff",  Game.fleet.secretUrl
      Game.bindArrowKeys()
      return targetFleet
    else
      return false

Router.onBeforeAction "dataNotFound", only: "game"
