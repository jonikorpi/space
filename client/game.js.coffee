#
# Game

Template.game.helpers

  otherFleets: ->
    return Fleets.find
      secretUrl:
        $ne: Game.fleet.secretUrl

  stars: ->
    xPos = Game.fleet.loc[0]
    yPos = Game.fleet.loc[1]

    return Objects.find
      type: "star"
      "loc.0":
        $gte: xPos - Game.halfX
        $lte: xPos + Game.halfX
      "loc.1":
        $gte: yPos - Game.halfY
        $lte: yPos + Game.halfY

  planets: ->
    xPos = Game.fleet.loc[0]
    yPos = Game.fleet.loc[1]

    return Objects.find
      type: "planet"
      "loc.0":
        $gte: xPos - Game.halfX
        $lte: xPos + Game.halfX
      "loc.1":
        $gte: yPos - Game.halfY
        $lte: yPos + Game.halfY

  mapStars: ->
    return Objects.find
      type: "star"

  mapPlanets: ->
    return Objects.find
      type: "planet"

  loots: ->
    return Loot.find({})

  gameAttributes: ->
    return {
      "data-view": Session.get("view")
    }

Template.game.events

  "click .movement-controls": (event) ->
    x = Game.cursorX - Game.docWidth * 0.5
    y = Game.cursorY - Game.docHeight * 0.5

    moveX = x / Game.coordinateScale
    moveY = y / Game.coordinateScale

    if Session.get("view") == "map"
      moveX = moveX / Game.mapScale
      moveY = moveY / Game.mapScale

    Game.moveFleet Game.fleet.secretUrl, moveX, moveY

Template.game.onRendered ->
  
  Game.setCoordinateScales()
