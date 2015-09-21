@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    if star.properties.name == ""
      nameToSet = star.properties.desig
    else
      nameToSet = star.properties.name

    starObject =
      loc: [
        Math.round(star.geometry.coordinates[1] * Game.coordinateMultiplier)
        Math.round(star.geometry.coordinates[0] * Game.coordinateMultiplier)
      ]
      name: nameToSet
      size: star.properties.mag
      color: star.properties.bv
      energy: Math.round(star.properties.mag * Game.starEnergyMultiplier)

    Objects.insert starObject
