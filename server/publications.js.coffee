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
          [ xPos - Game.halfX, yPos - Game.halfY ]
          [ xPos + Game.halfX, yPos - Game.halfY ]
          [ xPos + Game.halfX, yPos + Game.halfY ]
          [ xPos - Game.halfX, yPos + Game.halfY ]
          [ xPos - Game.halfX, yPos - Game.halfY ]
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
          [ xPos - Game.mapHalfX, yPos - Game.mapHalfY ]
          [ xPos + Game.mapHalfX, yPos - Game.mapHalfY ]
          [ xPos + Game.mapHalfX, yPos + Game.mapHalfY ]
          [ xPos - Game.mapHalfX, yPos + Game.mapHalfY ]
          [ xPos - Game.mapHalfX, yPos - Game.mapHalfY ]
        ]
  ,
    fields:
      maxEnergy: 0
      maxResources: 0

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
          [ xPos - Game.halfX, yPos - Game.halfY ]
          [ xPos + Game.halfX, yPos - Game.halfY ]
          [ xPos + Game.halfX, yPos + Game.halfY ]
          [ xPos - Game.halfX, yPos + Game.halfY ]
          [ xPos - Game.halfX, yPos - Game.halfY ]
        ]

#
# Indexing

Meteor.startup ->
  Fleets._ensureIndex
    loc: "2d"
    secretUrl: 1
  ,
    min: Game.galaxyBoundX * -1
    max: Game.galaxyBoundX

  Objects._ensureIndex
    loc: "2d"
  ,
    min: Game.galaxyBoundX * -1
    max: Game.galaxyBoundX

  Loot._ensureIndex
    loc: "2d"
  ,
    min: Game.galaxyBoundX * -1
    max: Game.galaxyBoundX
