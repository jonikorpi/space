Router.configure
  layoutTemplate: "layout"
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"

Router.route "/",
  template: "home"
  name: "home"

Router.route "/secret-link/:secretUrl",
  template: "game"
  name: "game"
  waitOn: ->
    console.log "subscribing to thisFleet…"
    return Meteor.subscribe "thisFleet", @.params.secretUrl
  data: ->
    console.log "setting data to thisFleet"
    targetFleet = Fleets.findOne {secretUrl: @.params.secretUrl}
    if targetFleet
      Game.fleetID = targetFleet._id
      Game.secretUrl = targetFleet.secretUrl
      Game.xPos = targetFleet.loc.coordinates[1]
      Game.yPos = targetFleet.loc.coordinates[0]
      Meteor.subscribe "nearbyFleets", Game.yPos, Game.xPos
      return targetFleet
    else
      return false

Router.onBeforeAction "dataNotFound", only: "game"
