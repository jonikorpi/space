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

    Fleets.update
      secretUrl: secretUrl
    ,
      $set:
        lastMove: new Date()
        loc: [currentX+moveX, currentY+moveY]
        lastLoc: [currentX, currentY]

  jumpFleet: (secretUrl, newX, newY, currentX, currentY) ->
    # TODO: checks

    unless currentX
      currentX = newX
    unless currentY
      currentY = newY

    Fleets.update
      secretUrl: secretUrl
    ,
      $set:
        moveStarted: moment()
        moveEnds: moment().add(1, "seconds")
        loc: [newX, newY]
        lastLoc: [currentX, currentY]

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
