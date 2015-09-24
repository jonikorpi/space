Meteor.startup ->

  if Fleets.find().count() == 0
    console.log "Creating seed fleets"
    Meteor.call "startFleet", Random.id() for [1..3]

  # Thanks to Olaf Frohn for the data! https://github.com/ofrohn
  if Objects.find().count() == 0
    console.log "Creating seed stars"
    stars = JSON.parse Assets.getText("stars.6.json")
    for index, star of stars.features
      Meteor.call "createStar", star
