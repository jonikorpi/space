#
# Planets

Template.planet.helpers

  planetAttributes: ->
    offsetX = (@loc[0] - Game.fleet.loc[0])
    offsetY = (@loc[1] - Game.fleet.loc[1])

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);
        -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);"
    }

  planetScaling: ->
    sizeFactor = @resources/200
    scale = 1+1*sizeFactor

    return {
      "style": "transform: scale(#{scale});
        -webkit-transform: scale(#{scale});"
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
      "style": "transform: rotate(#{rotate}deg);
        -webkit-transform: rotate(#{rotate}deg);"
    }

Template.planet.onRendered ->
  Game.renderEntitiesIn()

#
# Map planet

Template.mapPlanet.helpers

  mapPlanetAttributes: ->
    offsetX = (@loc[0] - Game.fleet.loc[0]) * Game.mapScale
    offsetY = (@loc[1] - Game.fleet.loc[1]) * Game.mapScale

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);
        -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
    }

Template.mapPlanet.events

  "click .planet": (event, template) ->
    targetOffset = Math.round(1 + template.data.resources/450)
    x = template.data.loc[0] - Game.fleet.loc[0] - targetOffset
    y = template.data.loc[1] - Game.fleet.loc[1] - targetOffset
    Game.moveFleet Game.fleet.secretUrl, x, y

Template.mapPlanet.onRendered ->
  Game.renderEntitiesIn()
