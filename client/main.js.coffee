#
# Globals

Game.body = $("body")
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
  Meteor.call "moveFleet", secretUrl, moveX, moveY, Game.xPos, Game.yPos, (error, results) ->
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

Game.renderEntitiesIn = ->
  $(".rendering-in").removeClass("rendering-in")

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
    console.log "finding stars"
    return Objects.find({type: "star"})

  planets: ->
    console.log "finding planets"
    return Objects.find({type: "planet"})

Template.game.events

  "click [data-player-fleet] .fleet-model": (event) ->
    Game.body.addClass("zoomed-in")

  "click .zoom-out": (event) ->
    Game.body.removeClass("zoomed-in")

  "click .movement-controls": (event) ->
    x = Game.cursorX - Game.docWidth * 0.5
    y = Game.cursorY - Game.docHeight * 0.5

    moveX = x / Game.coordinateScale
    moveY = y / Game.coordinateScale

    Game.moveFleet Game.secretUrl, moveX, moveY

Template.game.onRendered ->
  Game.setCoordinateScales()

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
        "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0); -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
      }

  shipAttributes: ->
    return {
      "data-fleet-id": this.index
    }

Template.fleet.onRendered ->
  requestAnimationFrame(Game.renderEntitiesIn)

#
# Objects

Template.star.helpers

  starAttributes: ->
    offsetX = @loc[0] - Game.xPos
    offsetY = @loc[1] - Game.yPos

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0); -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
    }

  starScaling: ->
    sizeFactor = @energy/2000
    scale = 1+1*sizeFactor

    return {
      "style": "transform: scale(#{scale}); -webkit-transform: scale(#{scale});"
    }

  starModel: ->
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
  requestAnimationFrame(Game.renderEntitiesIn)

# Template.star.onRendered ->
  # @.$(".rendering-in").removeClass("rendering-in")

Template.planet.helpers

  planetAttributes: ->
    offsetX = @loc[0] - Game.xPos
    offsetY = @loc[1] - Game.yPos

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0); -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
    }

  planetScaling: ->
    sizeFactor = @resources/10000
    scale = 0.5+1*sizeFactor

    return {
      "style": "transform: scale(#{scale}); -webkit-transform: scale(#{scale});"
    }

  planetModel: ->
    offX = @offsetLoc[0]
    offY = @offsetLoc[1]

    if offX < 0 && offY < 0
      rotate = 270
    else if offX >= 0 && offY < 0
      rotate = 0
    else if offX >= 0 && offY >= 0
      rotate = 90
    else if offX <  0 && offY >= 0
      rotate = 180

    rotate += Game.rightAngle(offX, offY)

    return {
      "style": "transform: rotate(#{rotate}deg); -webkit-transform: rotate(#{rotate}deg);"
    }

Template.planet.onRendered ->
  requestAnimationFrame(Game.renderEntitiesIn)

#
# Cheats

Template.cheats.events

  "click .random-planet": (event) ->
    Meteor.call "moveToRandomPlanet", Game.secretUrl

  "click .random-star": (event) ->
    Meteor.call "moveToRandomStar", Game.secretUrl

  "click .random-spot": (event) ->
    Meteor.call "moveToRandomSpot", Game.secretUrl
