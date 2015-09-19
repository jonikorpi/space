Meteor.publish 'nearbyFleets', (yPos, xPos) ->
  # check options,
  #   sort: Object
  #   limit: Number
  foundFleets = Fleets.find
    loc:
      $geoWithin:
        $center: [
          [yPos, xPos]
          Game.colCount*0.62
        ]
  ,
    createdAt: 0
    secretUrl: 0
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
