#
# Player fleet

Meteor.publish "thisFleet", (secretUrl) ->
  return Fleets.find {
    secretUrl: secretUrl
  }

#
# Nearby stuff

Meteor.publish "nearbyStuff", (secretUrl) ->
  # TODO: checks

  this.autorun (computation) ->
    playerFleet = Fleets.findOne
      secretUrl: secretUrl

    xPos = playerFleet.loc[0]
    yPos = playerFleet.loc[1]

    fleets = Fleets.find
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

    objects = Objects.find
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

    loot = Loot.find
      loc:
        $geoWithin:
          $polygon: [
            [ xPos - Game.halfX, yPos - Game.halfY ]
            [ xPos + Game.halfX, yPos - Game.halfY ]
            [ xPos + Game.halfX, yPos + Game.halfY ]
            [ xPos - Game.halfX, yPos + Game.halfY ]
            [ xPos - Game.halfX, yPos - Game.halfY ]
          ]

    results = [
      fleets,
      objects,
      loot
    ]
    results
  return

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
