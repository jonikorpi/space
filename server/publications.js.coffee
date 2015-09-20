halfY = Game.rowCount * 1.5
halfX = Game.colCount * 1.5

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

  unless xPos == playerFleet.loc.x && yPos == playerFleet.loc.y
    return

  return Fleets.find
    "loc.x":
      $gte: xPos - halfX
      $lte: xPos + halfX
    "loc.y":
      $gte: yPos - halfY
      $lte: yPos + halfY
  ,
    fields:
      secretUrl: 0
      createdAt: 0

#
# Nearby objects

Meteor.publish "nearbyObjects", (secretUrl, xPos, yPos) ->
  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  unless xPos == playerFleet.loc.x && yPos == playerFleet.loc.y
    return

  return Objects.find
    "loc.x":
      $gte: xPos - halfX
      $lte: xPos + halfX
    "loc.y":
      $gte: yPos - halfY
      $lte: yPos + halfY
  # ,
  #   fields:
  #     energy: 0

#
# Indexing

Meteor.startup ->
  Fleets._ensureIndex
    "loc": 1
    "secretUrl": 1
    "_id": 1

  Objects._ensureIndex
    "loc": 1
    "_id": 1
