#
# Init/Ready

$ ->
  FastClick.attach document.body

  $(document).on "mousemove", (event) ->
    Game.cursorX = event.pageX
    Game.cursorY = event.pageY
    requestAnimationFrame(Game.movePointer)

  $(window).on "resize", (event) ->
    requestAnimationFrame(Game.setCoordinateScales)

#
# Layout

Template.layout.helpers

Template.layout.events

#
# Home

Template.home.helpers
  fleets: ->
    console.log "getting all fleets"
    return Fleets.find({}, {sort: {createdAt: -1}})

  # characters: ->
  #   console.log "getting all characters"
  #   return Characters.find({})

Template.home.events


Template.header.events
  "click .start-fleet": ->
    console.log "starting a fleet"
    # TODO: loading indicator
    newSecretUrl = Random.secret()
    Meteor.call "startFleet", newSecretUrl, (error, results) ->
      if error
        console.log error
      else
        targetFleet = Fleets.findOne _id: results
        Router.go "/secret-link/" + newSecretUrl

#
# Backdrop

Template.backdrop.helpers
  layer1: ->
    Game.moveBackdrop( Game.starSpeed * Game.starStep )
  layer2: ->
    Game.moveBackdrop( Game.starSpeed * Game.starStep1 )
  layer3: ->
    Game.moveBackdrop( Game.starSpeed * Game.starStep2 )

#
# HUD

Template.views.helpers

  mapButton: ->
    if Session.get("view") == "map"
      return {
        "data-button-active": true
      }

  areaButton: ->
    if Session.get("view") == "area"
      return {
        "data-button-active": true
      }

  fleetButton: ->
    if Session.get("view") == "fleet"
      return {
        "data-button-active": true
      }

Template.views.events

  "click .button": (event) ->
    Game.showView $(event.target).attr("data-button-value")

#
# Status

Template.status.helpers

  fleetStatus: ->
    return Session.get "fleet"

#
# Cheats

Template.cheats.events

  # "click .random-planet": (event) ->
  #   Meteor.call "moveToRandomPlanet", Game.fleet.secretUrl
