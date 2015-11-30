@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    # Set color to + if there's none
    if star.properties.bv == ""
      colorToSet = 0
    else
      colorToSet = star.properties.bv

    xLoc = Math.round(star.geometry.coordinates[0] * Game.coordinateMultiplier)
    yLoc = Math.round(star.geometry.coordinates[1] * Game.coordinateMultiplier)

    if xLoc < Game.galaxyBoundX*-1
      xLoc = Game.galaxyBoundX*-1
    if xLoc > Game.galaxyBoundX
      xLoc = Game.galaxyBoundX

    if yLoc < Game.galaxyBoundY*-1
      yLoc = Game.galaxyBoundY*-1
    if yLoc > Game.galaxyBoundY
      yLoc = Game.galaxyBoundY

    baseEnergy = 500
    energy = baseEnergy + Math.abs(Math.round((1+star.properties.mag*10) * (1+star.properties.bv*100)) )

    energyModifier = Math.abs( Math.round(1 + energy / baseEnergy) )
    planetCount = 1 # Math.abs( Math.round(energyModifier/3) )

    if star.properties.name == ""
      if star.properties.con == ""
        nameToSet = "#{star.properties.desig}-#{star.id}"
      else
        nameToSet = "#{star.properties.con}-#{star.properties.desig}"
    else
      nameToSet = star.properties.name

    Objects.insert
      loc: [ xLoc, yLoc ]
      type: "star"
      name: nameToSet
      energy: energy
      maxEnergy: energy

    console.log "NEW STAR: #{nameToSet}, with #{energy} energy at [#{xLoc},#{yLoc}]."

    for count in [1..planetCount]
      Meteor.call "createPlanet", xLoc, yLoc, energy, energyModifier, count+1, nameToSet


  createPlanet: (xStar, yStar, energy, energyModifier, count, starName) ->
    xLocModifier = _.random(0, 1)
    yLocModifier = _.random(0, 1)

    if xLocModifier == 0
      xLocModifier = -1 + (-1 * count)
    if yLocModifier == 0
      yLocModifier = -1 + (-1 * count)

    xLocModifier = (xLocModifier * count) + (xLocModifier * energyModifier)
    yLocModifier = (yLocModifier * count) + (yLocModifier * energyModifier)

    xPlanet = Math.round(xStar + xLocModifier)
    yPlanet = Math.round(yStar + yLocModifier)

    if xPlanet < Game.galaxyBoundX*-1
      xPlanet = Game.galaxyBoundX*-1
    if xPlanet > Game.galaxyBoundX
      xPlanet = Game.galaxyBoundX

    if yPlanet < Game.galaxyBoundY*-1
      yPlanet = Game.galaxyBoundY*-1
    if yPlanet > Game.galaxyBoundY
      yPlanet = Game.galaxyBoundY

    xOff = xStar-xPlanet
    yOff = yStar-yPlanet

    planetName = "#{starName} #{Game.romanize(count)}"
    resources = Math.round( 1 + energy/200 * Math.abs((1 + xLocModifier + yLocModifier)) )

    Objects.insert
      loc: [ xPlanet, yPlanet ]
      offsetLoc: [ xOff, yOff ]
      type: "planet"
      name: planetName
      resources: resources
      maxResources: resources

    console.log "NEW PLANET: #{planetName}, with #{resources} resources at [#{xPlanet},#{yPlanet}], [#{xOff}, #{yOff}] away from its star."
