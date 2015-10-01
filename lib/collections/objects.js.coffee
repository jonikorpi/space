@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    # Set color to + if there's none
    if star.properties.bv == ""
      colorToSet = 0
    else
      colorToSet = star.properties.bv

    xLoc = star.geometry.coordinates[0] * Game.coordinateMultiplier
    yLoc = star.geometry.coordinates[1] * Game.coordinateMultiplier

    energy = 500 + Math.abs(Math.round((1+star.properties.mag*10) * (1+star.properties.bv*100)) )
    energyModifier = Math.abs( Math.round(1 + energy / 200) )
    planetAmount = 1# + ( Math.abs( Math.round(energy / 5000) ) )

    if star.properties.name == ""
      nameToSet = "#{star.properties.desig}-#{star.id}"
    else
      nameToSet = star.properties.name

    Objects.insert
      loc: [ xLoc, yLoc ]
      type: "star"
      name: nameToSet
      energy: energy
      maxEnergy: energy

    console.log "NEW STAR: #{nameToSet}, with #{energy} energy at [#{xLoc},#{yLoc}]."

    for count in [1..planetAmount]
      Meteor.call "createPlanet", xLoc, yLoc, energy, energyModifier, count+1, nameToSet


  createPlanet: (xStar, yStar, energy, energyModifier, count, starName) ->
    xLocModifier = _.random(0, 1)
    yLocModifier = _.random(0, 1)

    if xLocModifier == 0
      xLocModifier = -1
    if yLocModifier == 0
      yLocModifier = -1

    xLocModifier = xLocModifier * _.random(energyModifier+3, energyModifier*5+3)
    yLocModifier = yLocModifier * _.random(energyModifier+3, energyModifier*5+3)

    xPlanet = Math.round(xStar + xLocModifier)
    yPlanet = Math.round(yStar + yLocModifier)
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
