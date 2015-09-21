@Fleets = new Mongo.Collection("fleets")

Meteor.methods

  # setCharactership: (gameID, shipID, slot, team) ->
  #   slotID = "#{team}.#{slot}"
  #   console.log "slotID is #{slotID}"
  #
  #   Games.update {
  #     _id: gameID
  #     "characters.slotID": slotID
  #   }, $set:
  #     "characters.$.fleetID": shipID

  startFleet: (newSecretUrl, x, y) ->
    unless x
      x = 0 + _.random(-7, 7)
    unless y
      y = 0 + _.random(-7, 7)

    Fleets.insert
      loc: [x, y]
      secretUrl: newSecretUrl
      secretInvite: Random.secret()
      createdAt: new Date()
      lastMove: new Date()
      name: "Fleet ID-#{_.random(10000, 99999)}"
      ships: [
        [1, 2, false]
        [1, 2, false]
        [1, 2, false]
        [1, 2, false]
        [1, 2, false]
      ]

      # , (error, results, ) ->
      #   console.log results
      #   console.log error

  moveFleet: (secretUrl, moveX, moveY) ->
    Fleets.update
      secretUrl: secretUrl
    ,
      $set:
        lastMove: new Date()
      $inc:
        "loc.0": moveX
        "loc.1": moveY

  jumpFleet: (secretUrl, newX, newY) ->
    Fleets.update
      secretUrl: secretUrl
    ,
      $set:
        lastMove: new Date()
        "loc.0": newX
        "loc.1": newY

  moveToRandomSpot: (secretUrl) ->
    newX = _.random( Game.galaxyBoundX / -10, Game.galaxyBoundX / 10 )
    newY = _.random( Game.galaxyBoundY / -10, Game.galaxyBoundY / 10 )
    Meteor.call "jumpFleet", secretUrl, newX, newY

  moveToRandomStar: (secretUrl) ->
    newX = _.random( Game.galaxyBoundX * -1, Game.galaxyBoundX * 1 )
    newY = _.random( Game.galaxyBoundY * -1, Game.galaxyBoundY * 1 )

    randomStar = Objects.findOne {},
      skip: _.random(1, 4559)

    Meteor.call "jumpFleet", secretUrl, randomStar.loc[0]-3, randomStar.loc[1]+1
