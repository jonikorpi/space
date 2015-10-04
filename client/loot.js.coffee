#
# Loot

Template.loot.helpers

  lootAttributes: ->
    offsetX = @loc[0] - Game.fleet.loc[0]
    offsetY = @loc[1] - Game.fleet.loc[1]

    return {
      "style": "transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);
        -webkit-transform: translate3d(#{-50 + offsetX*100}%, #{-50 + offsetY*100}%, 0);"
    }

Template.loot.onRendered ->
  Game.renderEntitiesIn( $(this.firstNode) )
