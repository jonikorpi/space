@Fleets = new Mongo.Collection("fleets")

Meteor.methods

  # setCharacterSlot: (gameID, shipID, slot, team) ->
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
      x = 6420 + _.random(-7, 7)
    unless y
      y = 161 + _.random(-7, 7)

    Fleets.insert
      secretUrl: newSecretUrl
      createdAt: new Date()
      lastMove: new Date()
      loc: [x, y]
      secretInvite: Random.id()
      # ships: [
      #   {
      #     slot: 1
      #     shipID: false
      #   }
      #   {
      #     slot: 2
      #     shipID: false
      #   }
      #   {
      #     slot: 3
      #     shipID: false
      #   }
      #   {
      #     slot: 4
      #     shipID: false
      #   }
      #   {
      #     slot: 1
      #     shipID: false
      #   }
      #   {
      #     slot: 2
      #     shipID: false
      #   }
      #   {
      #     slot: 3
      #     shipID: false
      #   }
      #   {
      #     slot: 4
      #     shipID: false
      #   }
      # ]
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
    newX = _.random( Game.galaxyBound / -10, Game.galaxyBound / 10 )
    newY = _.random( Game.galaxyBound / -10, Game.galaxyBound / 10 )
    Meteor.call "jumpFleet", secretUrl, newX, newY

  moveToRandomStar: (secretUrl) ->
    newX = _.random( Game.galaxyBound * -1, Game.galaxyBound * 1 )
    newY = _.random( Game.galaxyBound * -1, Game.galaxyBound * 1 )

    randomStar = Objects.findOne {},
      skip: _.random(1, 4559)

    Meteor.call "jumpFleet", secretUrl, randomStar.loc[0]-3, randomStar.loc[1]+1
