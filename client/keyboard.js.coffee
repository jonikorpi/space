Game.bindArrowKeys = ->
  Mousetrap.bind
    "left": ->
      Game.moveFleet Game.secretUrl, -1,  0
    "a":    ->
      Game.moveFleet Game.secretUrl, -1,  0
    "up":   ->
      Game.moveFleet Game.secretUrl,  0, -1
    "w":    ->
      Game.moveFleet Game.secretUrl,  0, -1
    "right":->
      Game.moveFleet Game.secretUrl,  1,  0
    "d":    ->
      Game.moveFleet Game.secretUrl,  1,  0
    "down": ->
      Game.moveFleet Game.secretUrl,  0,  1
    "s":    ->
      Game.moveFleet Game.secretUrl,  0,  1
    "esc":  ->
      $(".zoom-out").trigger "click"
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
