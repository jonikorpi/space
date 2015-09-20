Meteor.publish 'nearbyFleets', (secretUrl, yPos, xPos) ->
  # check options,
  #   sort: Object
  #   limit: Number

  halfY = Game.rowCount*0.5
  halfX = Game.colCount*0.5

  playerFleet = Fleets.findOne
    secretUrl: secretUrl

  unless yPos == playerFleet.loc.coordinates[0] && xPos == playerFleet.loc.coordinates[1]
    return

  foundFleets = Fleets.find
    loc:
      $geoWithin:
        $geometry:
          type: "Polygon"
          coordinates: [[
            [yPos-(halfY), xPos-(halfX)]
            [yPos-(halfY), xPos+(halfX)]
            [yPos+(halfY), xPos+(halfX)]
            [yPos+(halfY), xPos-(halfX)]
            [yPos-(halfY), xPos-(halfX)]
          ]]
  ,
    fields:
      secretUrl: 0
      createdAt: 0
  return foundFleets

Meteor.publish 'thisFleet', (secretUrl) ->
  return Fleets.find {
    secretUrl: secretUrl
  }

Meteor.startup ->
  Fleets._ensureIndex
    "loc": "2dsphere"
    "secretUrl": 1

# Meteor.publish 'singlePost', (id) ->
#   check id, String
#   Posts.find id
#
# Meteor.publish 'comments', (postId) ->
#   check postId, String
#   Comments.find postId: postId
#
# Meteor.publish 'notifications', ->
#   Notifications.find
#     userId: @userId
#     read: false
