@Objects = new Mongo.Collection("objects")

Meteor.methods

  createStar: (star) ->
    if star.properties.name == ""
      nameToSet = "S-" + star.properties.desig
    else
      nameToSet = star.properties.name

    starObject =
      loc:
        x: Math.round(star.geometry.coordinates[1]*1000)
        y: Math.round(star.geometry.coordinates[0]*1000)
      name: nameToSet
      size: star.properties.mag
      color: star.properties.bv
      energy: Math.round(star.properties.mag * Game.starEnergyMultiplier)

    console.log "Creating star:"
    console.log starObject

    Objects.insert starObject
