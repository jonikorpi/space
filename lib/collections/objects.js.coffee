@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    if star.properties.name == ""
      nameToSet = "SID-#{star.properties.desig}"
    else
      nameToSet = star.properties.name

    if star.properties.bv == ""
      colorToSet = 0
    else
      colorToSet = star.properties.bv

    starObject =
      loc: [
        Math.round(star.geometry.coordinates[0] * Game.coordinateMultiplier)
        Math.round(star.geometry.coordinates[1] * Game.coordinateMultiplier)
      ]

      name: nameToSet
      size: Math.abs( 1 + star.properties.bv )
      color: colorToSet
      energy: Math.abs( Math.round((1+star.properties.mag) * (1+star.properties.bv) * Game.starEnergyMultiplier) )

    Objects.insert starObject
