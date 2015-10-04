#
# Fleet

Template.fleet.helpers

Template.fleet.events

Template.fleet.helpers

  fleetAttributes: ->
    x = @loc[0]
    y = @loc[1]

    offsetX = x - Game.fleet.loc[0]
    offsetY = y - Game.fleet.loc[1]

    if Game.fleet.secretUrl == this.secretUrl
      isPlayerFleet = true
      offsetX =
      offsetY = 0
      style = ""
    else
      style = "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);
       -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);"

    return {
      "data-player-fleet": isPlayerFleet
      "style": style
    }

  fleetModelAttributes: ->
    x = @lastLoc[0] - @loc[0]
    y = @lastLoc[1] - @loc[1]
    angle = Game.rightAngle(x, y) + 180

    # Should've paid more attention in maths class…
    if      x <  0 && y <  0
      angle = 270 - angle
    else if x >= 0 && y <  0
      angle = 90 + angle
    else if x >= 0 && y >= 0
      angle = 90 + angle
    else if x <  0 && y >= 0
      angle = 270 - angle

    # duration = Game.hypotenuse(x, y) * Game.fleetSpeed

    return {
      "style": "transform: rotate(#{angle}deg);
        -webkit-transform: rotate(#{angle}deg);"
    }

  shipAttributes: ->
    return {
      "data-fleet-id": this.index
    }

Template.fleet.onRendered ->
  Game.renderEntitiesIn()
