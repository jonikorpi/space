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
      name: "Fleet ID-#{Random.id()}"
      animation: false
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
    randomStar = Objects.findOne {type: "star"},
      skip: _.random(1, 4550)

    Meteor.call "jumpFleet", secretUrl, randomStar.loc[0]+3, randomStar.loc[1]+1

  moveToRandomPlanet: (secretUrl) ->
    randomPlanet = Objects.findOne { type: "planet"},
      skip: _.random(1, 21980)

    Meteor.call "jumpFleet", secretUrl, randomPlanet.loc[0]+3, randomPlanet.loc[1]+1
