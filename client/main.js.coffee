#
# Non-Meteor methods

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
    newSecretUrl = Random.secret()
    Meteor.call "startFleet", newSecretUrl, (error, results) ->
      if error
        console.log error
      else
        targetFleet = Fleets.findOne _id: results
        Router.go "/secret-link/" + newSecretUrl


#
# Game

Template.game.helpers

  otherFleets: ->
    console.log "finding other fleets"
    return Fleets.find({
      _id:
        $not: Game.fleetID
    }, {sort: {createdAt: -1}})

  stars: ->
    console.log "finding objects"
    return Objects.find({})

Template.game.events

  "click .move": (event) ->
    button = $(event.target)
    buttonX = button.attr("data-move-x")
    buttonY = button.attr("data-move-y")
    moveX = 0
    moveY = 0

    if buttonX
      moveX = +buttonX
    if buttonY
      moveY = +buttonY

    Game.moveFleet Game.secretUrl, moveX, moveY

  "click .zoom-in": (event) ->
    Game.body.addClass("zoomed-in")

  "click .zoom-out": (event) ->
    Game.body.removeClass("zoomed-in")

Template.game.onRendered ->
  movementControls = @.$(".movement-controls")

  for x in [1..Game.colCount*3]
    for y in [1..Game.rowCount*3]
      offsetX = x - (Game.colCount*3+1)/2
      offsetY = y - (Game.rowCount*3+1)/2
      unless offsetX == 0 && offsetY == 0
        movementControls.append "<button style='left: #{offsetX*100}%; top: #{offsetY*100}%' class='move' type='button' data-move-x='#{offsetX}' data-move-y='#{offsetY}'></button>"


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
# Fleet

Template.fleet.helpers

Template.fleet.events

Template.fleet.helpers

  fleetAttributes: ->
    if Game.secretUrl == this.secretUrl
      return {
        "data-player-fleet": true
      }
    else
      offsetX = @loc[0] - Game.xPos
      offsetY = @loc[1] - Game.yPos

      return {
        "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0); -webkit-transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
      }

  shipAttributes: ->
    return {
      "data-fleet-id": this.index
    }

#
# Objects

Template.star.helpers

  starAttributes: ->
    console.log "setting offset positions for stars"
    offsetX = @loc[0] - Game.xPos
    offsetY = @loc[1] - Game.yPos

    return {
      "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0); -webkit-transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
    }

  starScaling: ->
    sizeFactor = @energy/4000

    return {
      "style": "transform: scale(#{1+1*sizeFactor}); -webkit-transform: scale(#{1+1*sizeFactor});"
    }

  starColors: ->
    if @energy < 1000
      # Blues
      hue =        215 + (1 + @energy/100000)
      saturation =  91 * (1 + @energy/100000)
      lightness =   62 * (1 + @energy/100000)
    else if @energy < 3000
      # Whites
      hue =         45 - (1 + @energy/100000)
      saturation =  14 * (1 - @energy/100000)
      lightness =   91 * (1 - @energy/100000)
    else if @energy < 6000
      # Yellows
      hue =         50 - (1 + @energy/100000)
      saturation =  91 * (1 - @energy/100000)
      lightness =   85 * (1 - @energy/100000)
    else if @energy < 8000
      # Oranges
      hue =         25 - (1 + @energy/100000)
      saturation =  91 * (1 - @energy/100000)
      lightness =   76 * (1 - @energy/100000)
    else if @energy >= 8000
      # Reds
      hue =         10 - (1 + @energy/100000)
      saturation = 100 * (1 - @energy/100000)
      lightness =   76 * (1 - @energy/100000)

    return {
      "style": "background-color: hsl(#{hue}, #{saturation}%, #{lightness}%); color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
    }

Template.star.onRendered ->
  # @.$(".rendering-in").removeClass("rendering-in")

#
# Cheats

Template.cheats.events

  "click .random-star": (event) ->
    Meteor.call "moveToRandomStar", Game.secretUrl

  "click .random-spot": (event) ->
    Meteor.call "moveToRandomSpot", Game.secretUrl
