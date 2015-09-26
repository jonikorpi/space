halfY = Game.ySize * 3
halfX = Game.xSize * 3

#
# Player fleet

Meteor.publish "thisFleet", (secretUrl) ->
  return Fleets.find {
    secretUrl: secretUrl
  }

#
# Nearby fleets

Meteor.publish "nearbyFleets", (secretUrl) ->
  # TODO: checks

  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  xPos = playerFleet.loc[0]
  yPos = playerFleet.loc[1]

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

Meteor.publish "nearbyObjects", (secretUrl) ->
  # TODO: checks

  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  xPos = playerFleet.loc[0]
  yPos = playerFleet.loc[1]

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

#
# Nearby loot

Meteor.publish "nearbyLoot", (secretUrl) ->
  # TODO: checks

  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  xPos = playerFleet.loc[0]
  yPos = playerFleet.loc[1]

  return Loot.find
    loc:
      $geoWithin:
        $polygon: [
          [ xPos - halfX, yPos - halfY ]
          [ xPos + halfX, yPos - halfY ]
          [ xPos + halfX, yPos + halfY ]
          [ xPos - halfX, yPos + halfY ]
          [ xPos - halfX, yPos - halfY ]
        ]

#
# Indexing

Meteor.startup ->
  Fleets._ensureIndex
    loc: "2d"
    secretUrl: 1
  ,
    min: Game.galaxyBoundX*2 * -1
    max: Game.galaxyBoundX*2

  Objects._ensureIndex
    loc: "2d"
  ,
    min: Game.galaxyBoundX*2 * -1
    max: Game.galaxyBoundX*2

  Loot._ensureIndex
    loc: "2d"
  ,
    min: Game.galaxyBoundX*2 * -1
    max: Game.galaxyBoundX*2
