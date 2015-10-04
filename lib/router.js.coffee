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
      Game.fleet = targetFleet
      Meteor.subscribe "nearbyFleets",  Game.fleet.secretUrl, Game.fleet.loc
      Meteor.subscribe "nearbyObjects", Game.fleet.secretUrl, Game.fleet.loc
      Meteor.subscribe "nearbyLoot",    Game.fleet.secretUrl, Game.fleet.loc
      Game.bindArrowKeys()
      return targetFleet
    else
      return false

Router.onBeforeAction "dataNotFound", only: "game"
