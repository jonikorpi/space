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
      Game.secretUrl = @.params.secretUrl
      Game.xPos = targetFleet.loc[0]
      Game.yPos = targetFleet.loc[1]
      console.log "subscribing to nearby fleets [#{Game.xPos},#{Game.yPos}]…"
      Meteor.subscribe "nearbyFleets", Game.secretUrl, Game.xPos, Game.yPos
      console.log "subscribing to nearby objects [#{Game.xPos},#{Game.yPos}]…"
      Meteor.subscribe "nearbyObjects", Game.secretUrl, Game.xPos, Game.yPos
      return targetFleet
    else
      return false

Router.onBeforeAction "dataNotFound", only: "game"
