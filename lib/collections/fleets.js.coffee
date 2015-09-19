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

  startFleet: (newSecretUrl, long, lat) ->
    unless long
      long = 0
    unless lat
      lat = 0

    Fleets.insert
      secretUrl: newSecretUrl
      createdAt: new Date()
      loc:
        type: "Point"
        coordinates: [long, lat]
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
        "loc.coordinates.1": moveX
        "loc.coordinates.0": moveY
