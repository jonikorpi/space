halfY = Game.ySize * 2
halfX = Game.xSize * 2

#
# Player fleet

Meteor.publish "thisFleet", (secretUrl) ->
  return Fleets.find {
    secretUrl: secretUrl
  }

#
# Nearby fleets

Meteor.publish "nearbyFleets", (secretUrl, xPos, yPos) ->
  # check options,
  #   sort: Object
  #   limit: Number

  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  unless xPos == playerFleet.loc[0] && yPos == playerFleet.loc[1]
    return

  return Fleets.find
    secretUrl:
      $ne: secretUrl
    loc:
      $geoWithin:
        $polygon: [
          [ xPos - halfX, yPos - halfY ]
          [ xPos + halfX, yPos - halfY ]
          [ xPos + halfX, yPos + halfY ]
          [ xPos - halfX, yPos + halfY ]
          [ xPos - halfX, yPos - halfY ]
        ]
  ,
    fields:
      secretUrl: 0
      createdAt: 0
      lastMove: 0

#
# Nearby objects

Meteor.publish "nearbyObjects", (secretUrl, xPos, yPos) ->
  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  unless xPos == playerFleet.loc[0] && yPos == playerFleet.loc[1]
    return

  return Objects.find
    loc:
      $geoWithin:
        $polygon: [
          [ xPos - halfX, yPos - halfY ]
          [ xPos + halfX, yPos - halfY ]
          [ xPos + halfX, yPos + halfY ]
          [ xPos - halfX, yPos + halfY ]
          [ xPos - halfX, yPos - halfY ]
        ]
  # ,
  #   fields:
  #     energy: 0

#
# Indexing

Meteor.startup ->
  Fleets._ensureIndex
    loc: "2d"
    secretUrl: 1
    _id: 1
  ,
    min: Game.galaxyBoundX*2 * -1
    max: Game.galaxyBoundX*2

  Objects._ensureIndex
    loc: "2d"
    _id: 1
  ,
    min: Game.galaxyBoundX*2 * -1
    max: Game.galaxyBoundX*2
