Game.bindArrowKeys = ->
  Mousetrap.bind
    "left": ->
      Game.moveFleet Game.fleet.secretUrl, -1,  0
    "a":    ->
      Game.moveFleet Game.fleet.secretUrl, -1,  0
    "up":   ->
      Game.moveFleet Game.fleet.secretUrl,  0, -1
    "w":    ->
      Game.moveFleet Game.fleet.secretUrl,  0, -1
    "right":->
      Game.moveFleet Game.fleet.secretUrl,  1,  0
    "d":    ->
      Game.moveFleet Game.fleet.secretUrl,  1,  0
    "down": ->
      Game.moveFleet Game.fleet.secretUrl,  0,  1
    "s":    ->
      Game.moveFleet Game.fleet.secretUrl,  0,  1
    "1":  ->
      Game.showView "map"
    "2":  ->
      Game.showView "area"
    "3":  ->
      Game.showView "fleet"
    "esc":  ->
      Game.showView "area"
    "space": (event) ->
      event.preventDefault()
      $("[data-player-fleet] .fleet-model").trigger "click"
    "0": ->
      Game.toggleDebug()
  , "keyup"

Game.resumeArrowKeys = ->
  Mousetrap.unpause();

Game.pauseArrowKeys = ->
  Mousetrap.pause();
