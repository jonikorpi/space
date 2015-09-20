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
        gameElement = $(".game")
        gameElement.addClass("warp")
        playerFleet.on "transitionEnd webkitTransitionEnd", (event) ->
          if $(event.target).is(@)
            gameElement.removeClass("warp")
            playerFleet.off "transitionEnd webkitTransitionEnd"

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
    moveBackdrop( Game.starSpeed * Game.starStep )
  layer2: ->
    moveBackdrop( Game.starSpeed * Game.starStep1 )
  layer3: ->
    moveBackdrop( Game.starSpeed * Game.starStep2 )

#
# Fleet

Template.fleet.helpers

Template.fleet.events

Template.otherFleet.helpers

  fleetAttributes: ->
    console.log "setting offset positions for other fleets"
    offsetX = @loc.x - Game.xPos
    offsetY = @loc.y - Game.yPos

    return {
      "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0); -webkit-transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
    }

Template.otherFleet.onRendered ->
  # @.$(".rendering-in").removeClass("rendering-in")

#
# Objects

Template.star.helpers

  starAttributes: ->
    console.log "setting offset positions for stars"
    offsetX = @loc.x - Game.xPos
    offsetY = @loc.y - Game.yPos

    return {
      "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0); -webkit-transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
    }

  starModelAttributes: ->
    console.log "setting star model attributes"
    sizeFactor = @size/2

    if @color < 0
      # Blues
      hue =        220 * (1 + @color/-5)
      saturation = 100 * (1 - @color/-2)
      lightness =   50 * (1 + @color/-1)
    else if @color < 0.31
      # Whites
      hue =         45
      saturation = 100 * (0 + @color/5)
      lightness =   50 * (1 + @color)
    else if @color < 0.7
      # Yellows
      hue =         45 * (1 + @color/10)
      saturation = 100 * (1 - @color/10)
      lightness =   50 * (1 + @color)
    else if @color < 1.0
      # Oranges
      hue =         25 * (1 + @color/10)
      saturation = 100 * (1 - @color/10)
      lightness =   50 * (1 + @color/2)
    else if @color < 1.5
      # Reds
      hue =         10 * (1 + @color/10)
      saturation = 100 * (1 - @color/10)
      lightness =   50 * (1 + @color/2)
    else if @color >= 1.5
      # Really reds
      hue =          1 * (1 + @color/10)
      saturation = 100 * (1 - @color/10)
      lightness =   50 * (1 + @color/2)

    return {
      "style": "transform: scale(#{sizeFactor}); -webkit-transform: scale(#{sizeFactor}); background-color: hsl(#{hue}, #{saturation}%, #{lightness}%); color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
    }

Template.star.onRendered ->
  # @.$(".rendering-in").removeClass("rendering-in")
