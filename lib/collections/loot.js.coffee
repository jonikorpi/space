@Loot = new Mongo.Collection("loot")

Meteor.methods

  addLoot: (x, y, type, amount) ->
    Loot.insert
      loc: [x, y]
      type: type
      amount: amount
