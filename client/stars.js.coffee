#
# Stars

Game.starColor = (energy) ->
  if energy < 1000
    # Blues
    hue =        215 + (1 + energy/100000)
    saturation =  91 * (1 + energy/100000)
    lightness =   85 * (1 + energy/100000)
  else if energy < 3000
    # Whites
    hue =         45 - (1 + energy/100000)
    saturation =  23 * (1 - energy/100000)
    lightness =   91 * (1 - energy/100000)
  else if energy < 6000
    # Yellows
    hue =         50 - (1 + energy/100000)
    saturation =  76 * (1 - energy/100000)
    lightness =   91 * (1 - energy/100000)
  else if energy < 8000
    # Oranges
    hue =         25 - (1 + energy/100000)
    saturation =  61 * (1 - energy/100000)
    lightness =   91 * (1 - energy/100000)
  else if energy >= 8000
    # Reds
    hue =          3 - (1 + energy/100000)
    saturation = 100 * (1 - energy/100000)
    lightness =   76 * (1 - energy/100000)

  return {
    hue: hue
    saturation: saturation
    lightness: lightness
  }

Template.star.helpers

  starAttributes: ->
    offsetX = (@loc[0] - Game.fleet.loc[0])
    offsetY = (@loc[1] - Game.fleet.loc[1])

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0); -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
    }

  starScaling: ->
    sizeFactor = @energy/200
    scale = 1+1*sizeFactor

    return {
      "style": "transform: scale(#{scale}); -webkit-transform: scale(#{scale});"
    }

  starModel: ->
    starColor = Game.starColor(@energy)
    hue = starColor.hue
    saturation = starColor.saturation
    lightness = starColor.lightness

    return {
      "style": "background-color: hsl(#{hue}, #{saturation}%, #{lightness}%);
                           color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
    }

Template.star.onRendered ->
  Game.renderEntitiesIn()

#
# Map stars

Template.mapStar.helpers

  mapStarAttributes: ->
    offsetX = (@loc[0] - Game.fleet.loc[0]) * Game.mapScale
    offsetY = (@loc[1] - Game.fleet.loc[1]) * Game.mapScale

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);
        -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0)"
    }

  mapStarScaling: ->
    sizeFactor = @energy/30000
    scale = 0.09 + Math.abs(0-1*sizeFactor)

    return {
      "style": "transform: scale(#{scale}); -webkit-transform: scale(#{scale});"
    }

  mapStarModel: ->
    starColor = Game.starColor(@energy)
    hue = starColor.hue
    saturation = starColor.saturation
    lightness = starColor.lightness

    return {
      "style": "background-color: hsl(#{hue}, #{saturation}%, #{lightness}%);
                           color: hsl(#{hue}, #{saturation}%, #{lightness}%);"
    }

Template.mapStar.events

  "click .star": (event, template) ->
    targetOffset = Math.round(1 + template.data.energy/750)
    x = template.data.loc[0] - Game.fleet.loc[0] - targetOffset
    y = template.data.loc[1] - Game.fleet.loc[1] - targetOffset
    Game.moveFleet Game.fleet.secretUrl, x, y

Template.mapStar.onRendered ->
  Game.renderEntitiesIn()
