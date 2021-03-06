@Fleets = new Mongo.Collection("fleets")

Meteor.methods

  startFleet: (newSecretUrl, x, y) ->
    # TODO: checks

    unless x
      x = 0 + _.random(-7, 7)
    unless y
      y = 0 + _.random(-7, 7)

    Fleets.insert
      loc: [x, y]
      lastLoc: [x, y+1]
      lastMove: new Date()
      secretUrl: newSecretUrl
      secretInvite: Random.secret()
      createdAt: new Date()
      energy: 0
      name: "Unnamed Fleet"
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
    # TODO: check current position matches

    fleet = Fleets.findOne
      secretUrl: secretUrl

    currentX = fleet.loc[0]
    currentY = fleet.loc[1]

    energyCost = Game.hypotenuse(moveX, moveY) * Game.energyPerUnit

    if energyCost# < 1000
      energyCost = 0
    else
      Meteor.call "addLoot", currentX, currentY, "energy", energyCost

    newX = currentX+moveX
    newY = currentY+moveY

    if newX < Game.galaxyBoundX*-1
      newX = Game.galaxyBoundX*-1
    if newX > Game.galaxyBoundX
      newX = Game.galaxyBoundX

    if newY < Game.galaxyBoundY*-1
      newY = Game.galaxyBoundY*-1
    if newY > Game.galaxyBoundY
      newY = Game.galaxyBoundY

    Fleets.update
      secretUrl: secretUrl
    ,
      $set:
        lastMove: new Date()
        loc: [newX, newY]
        lastLoc: [currentX, currentY]
        energy: fleet.energy - energyCost
