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
      x = 64196 + _.random(-7, 7)
    unless y
      y = 1611 + _.random(-7, 7)

    Fleets.insert
      secretUrl: newSecretUrl
      createdAt: new Date()
      loc:
        x: x
        y: y
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

  moveFleet: (fleetID, moveX, moveY) ->
    Fleets.update fleetID,
      $inc:
        "loc.x": moveX
        "loc.y": moveY
