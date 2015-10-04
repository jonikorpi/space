#
# Globals

Game.movementPointer = $(".movement-pointer")
Game.cursorX = 0
Game.cursorY = 0

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
# Non-Meteor methods

Game.setCoordinateScales = ->
  Game.docWidth = $(window).width()
  Game.docHeight = $(window).height()
  Game.coordinateScale = $("#sizer-entity").width()

Game.moveFleet = (secretUrl, moveX, moveY) ->
  console.log "moveFleet by #{moveX}, #{moveY}"
  Meteor.call "moveFleet", secretUrl, moveX, moveY, (error, results) ->
    if error
      console.log error
    else
      playerFleet = $("[data-player-fleet]")
      Game.body.addClass("warp")
      playerFleet.on "animationEnd webkitAnimationEnd", (event) ->
        if $(event.target).is(@)
          Game.body.removeClass("warp")
          playerFleet.off "animationEnd webkitAnimationEnd"

Game.moveBackdrop = (number) ->
  xPos = Game.fleet.loc[0] * number
  yPos = Game.fleet.loc[1] * number
  xPosRounded = Math.ceil(xPos / 100)
  yPosRounded = Math.ceil(yPos / 100)

  transform = "transform: translate( #{-xPos}vw, #{-yPos}vh ); -webkit-transform: translate( #{-xPos}vw, #{-yPos}vh );"
  left = ""
  top = ""

  if xPos > 100
    left = "left: #{ 100*xPosRounded - 100 }vw;"
  if xPos < -100
    left = "left: #{ 100*xPosRounded }vw;"
  if yPos > 100
    top =   "top: #{ 100*yPosRounded - 100 }vh;"
  if yPos < -100
    top =   "top: #{ 100*yPosRounded }vh;"

  style = transform + left + top

  return {
    style: style
  }

Game.movePointer = ->
  x = Game.cursorX - Game.docWidth * 0.5
  y = Game.cursorY - Game.docHeight * 0.5

  if x == 0 && y == 0
    return

  angle = Game.rightAngle(x, y)

  # Should've paid more attention in maths class…
  if x < 0 && y < 0
    rotate = 270 - angle
  else if x >= 0 && y < 0
    rotate = 90 + angle
  else if x >= 0 && y >= 0
    rotate = 90 + angle
  else if x <  0 && y >= 0
    rotate = 270 - angle

  rotate = rotate
  scale = Game.hypotenuse(x, y)

  $(".movement-pointer").css
    "transform":         "rotateZ(#{rotate}deg) scaleY(#{scale}) "
    "-webkit-transform": "rotateZ(#{rotate}deg) scaleY(#{scale}) "

Game.renderEntitiesIn = (entity) ->
  entity.removeClass("rendering-in")

Game.showView = (view) ->
  switch view
    when "map"
      Game.body.attr("data-view", "map")
    when "area"
      Game.body.attr("data-view", "area")
    when "fleet"
      Game.body.attr("data-view", "fleet")

  Session.set "view", view

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
