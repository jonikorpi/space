@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    if star.properties.name == ""
      nameToSet = "SID-#{star.properties.desig}"
    else
      nameToSet = star.properties.name

    starObject =
      loc: [
        Math.round(star.geometry.coordinates[1] * Game.coordinateMultiplier)
        Math.round(star.geometry.coordinates[0] * Game.coordinateMultiplier)
      ]

      name: nameToSet
      size: Math.abs( 1 + star.properties.bv )
      color: star.properties.bv
      energy: Math.abs( Math.round(star.properties.mag * star.properties.bv * Game.starEnergyMultiplier) )

    Objects.insert starObject
