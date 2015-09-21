Meteor.startup ->

  if Fleets.find().count() == 0
    console.log "Creating seed fleets"
    Meteor.call "startFleet", Random.id() for [1..3]

  if Objects.find().count() == 0
    console.log "Creating seed stars"
    stars = JSON.parse Assets.getText("stars.6.json")
    console.log "Creating #{stars.features.size} stars"
    for index, star of stars.features
      Meteor.call "createStar", star
