# Game.bindArrowKeys = ->
#   $(document).on "keydown", (event) ->
#     if $(".fleet.selected").length > 0
#       switch event.which
#         when 37 # left
#           moveCharacter("left")
#         when 38 # up
#           moveCharacter("up")
#         when 39 # right
#           moveCharacter("right")
#         when 40 # down
#           moveCharacter("down")
#         else
#           return
#       event.preventDefault()
#
# Game.unbindArrowKeys = ->
#   $(document).off "keydown"
