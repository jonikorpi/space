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
      Game.body.removeClass().addClass("zoomed-out")
    "2":  ->
      Game.body.removeClass()
    "3":  ->
      Game.body.removeClass().addClass("zoomed-in")
    "esc":  ->
      Game.body.removeClass()
    "space": (event) ->
      event.preventDefault()
      $("[data-player-fleet] .fleet-model").trigger "click"
    ".": ->
      Game.body.toggleClass("debug")
  , "keyup"

Game.resumeArrowKeys = ->
  Mousetrap.unpause();

Game.pauseArrowKeys = ->
  Mousetrap.pause();
