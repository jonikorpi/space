@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    if star.properties.name == ""
      nameToSet = "ID-#{star.properties.desig}"
    else
      nameToSet = star.properties.name

    if star.properties.bv == ""
      colorToSet = 0
    else
      colorToSet = star.properties.bv

    energy = 500 + Math.abs(Math.round((1+star.properties.mag*10) * (1+star.properties.bv*100)) )

    starObject =
      loc: [
        Math.round(star.geometry.coordinates[0] * Game.coordinateMultiplier)
        Math.round(star.geometry.coordinates[1] * Game.coordinateMultiplier)
      ]
      name: nameToSet
      energy: energy
      maxEnergy: energy

    Objects.insert starObject
