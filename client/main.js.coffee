#
# Non-Meteor methods

moveBackdrop = (number) ->
  xPos = Game.xPos * number
  yPos = Game.yPos * number
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
    newSecretUrl = Random.id()
    Meteor.call "startFleet", newSecretUrl, (error, results) ->
      if error
        console.log error
      else
        targetFleet = Fleets.findOne _id: results
        Router.go "/secret-link/" + newSecretUrl


#
# Game

Template.game.helpers

Template.game.events

  "click .move": (event) ->
    event.stopPropagation()
    playerFleet = $(".player-fleet")

    button = $(event.target)
    buttonX = button.attr("data-move-x")
    buttonY = button.attr("data-move-y")
    moveX = 0
    moveY = 0

    if buttonX
      moveX = +buttonX
    if buttonY
      moveY = +buttonY

    Meteor.call "moveFleet", Game.fleetID, moveX, moveY, (error, results) ->
      if error
        console.log error
      else
        playerFleet
          .attr("style", "transform: translate3d(#{moveX*100}%, #{moveY*100}%, 0); -webkit-transform: translate3d(#{moveX*100}%, #{moveY*100}%, 0)")
          .addClass("warp")
          .on "transitionEnd webkitTransitionEnd", (event) ->
            if $(event.target).is(@)
              playerFleet
                .attr("style", "")
                .removeClass("warp")
                .off "transitionEnd webkitTransitionEnd"

Template.game.onRendered ->
  movementControls = $(".movement-controls")

  for x in [1..Game.colCount]
    for y in [1..Game.rowCount]
      movementControls.append "<button class='move' type='button' data-x-pos='#{x}' data-y-pos='#{y}' data-move-x='#{x - (Game.colCount+1)/2}' data-move-y='#{y - (Game.rowCount+1)/2}'></button>"


#
# Backdrop

Template.backdrop.helpers
  layer1: ->
    moveBackdrop( Game.starSpeed * Game.starStep )
  layer2: ->
    moveBackdrop( Game.starSpeed * Game.starStep1 )
  layer3: ->
    moveBackdrop( Game.starSpeed * Game.starStep2 )

#
# Fleet

Template.fleet.helpers

Template.fleet.events

Template.otherFleets.helpers

  otherFleets: ->
    console.log "finding other fleets"
    return Fleets.find({
      _id:
        $not: Game.fleetID
    }, {sort: {createdAt: -1}})

  offsetPositions: ->
    console.log "setting offset positions for other fleets"
    offsetX = @loc.coordinates[1] - Game.xPos
    offsetY = @loc.coordinates[0] - Game.yPos

    return {
      "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0); -webkit-transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
    }
