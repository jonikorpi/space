#
# Globals

Game = {}
# Game.rowCount = 8
# Game.colCount = 13
# Game.gameID = false
# Game.movesPerCharacter = 2
# Game.charactersPerTeam = 4

# Game.bindArrowKeys = ->
#   $(document).on "keydown", (event) ->
#     if $(".character.selected").length > 0
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

#
# Collections

Objects = new Mongo.Collection("objects")
Fleets = new Mongo.Collection("fleets")

#
# Routes

Router.configure
  layoutTemplate: "layout"

Router.route "/",
  template: "home"
  name: "home"
#
# Router.route "/:_id",
#   template: "game"
#   name: "game"
#   data: ->
#     targetGame = Games.findOne _id: @.params._id
#     console.log "routing to game #{@.params._id}"
#     console.log targetGame
#     Game.gameID = @.params._id
#     return targetGame

#
# Client

if Meteor.isClient

  #
  # Non-Meteor methods

  # moveCharacter = (x, y) ->
  #   character = $(".character.selected")
  #   slotID = character.attr("data-slotID")
  #   movables = $(".character.selected, .character-controls")
  #   xPos = +character.attr("data-x-pos")
  #   yPos = +character.attr("data-y-pos")
  #
  #   newX = xPos + x
  #   newY = yPos + y
  #
  #   if newX < 1
  #     newX = 1
  #   if newX > Game.colCount
  #     newX = Game.colCount
  #   if newY < 1
  #     newY = 1
  #   if newY > Game.rowCount
  #     newY = Game.rowCount
  #
  #   if newX == xPos && newY == yPos
  #     return false
  #   else
  #     movables.attr( {"data-x-pos": newX, "data-y-pos": newY} )
  #     Meteor.call "createMove", Game.gameID, slotID, newX, newY, "character #{slotID} moved to #{newX},#{newY}"

  #
  # Methods on the client

  Meteor.methods
    # routeToGame: (gameID) ->
    #   Router.go 'game', _id: gameID

  #
  # Layout

  Template.layout.helpers


  Template.layout.events


  #
  # Home

  Template.home.helpers
    # games: ->
    #   console.log "getting all games"
    #   return Games.find({}, {sort: {createdAt: -1}})
    #
    # characters: ->
    #   console.log "getting all characters"
    #   return Characters.find({})

  Template.home.events
    # "click .create-game": ->
    #   console.log "creating a game"
    #   Meteor.call "createGame"


  #
  # Game

  Template.game.helpers

    # moves: ->
    #   moves = Moves.find gameID: @_id, {sort: {createdAt: -1}}
    #   console.log "getting moves for game #{@_id}:"
    #   # console.log turns.fetch()
    #   return moves
    #
    # characterMap: ->
    #   console.log "getting all characters"
    #   # console.log Characters.find({})
    #   return Characters.find({})
    #
    # teams: ->
    #   return [
    #     {
    #       teamName: "Blue team"
    #       teamID: 1
    #       teamSlots: [1,2,3,4]
    #     }
    #     {
    #       teamName: "Red team"
    #       teamID: 2
    #       teamSlots: [1,2,3,4]
    #     }
    #   ]
    #
    # thisGameID: ->
    #   return @_id

  Template.game.events

    # "click .start-game": ->
    #   console.log "starting game #{@_id}"
    #   Meteor.call "startGame", @_id
    #
    # "click .stop-game": ->
    #   console.log "stopping game #{@_id}"
    #   Meteor.call "stopGame", @_id
    #
    # "click .end-turn": ->
    #   Meteor.call "endTurn", @_id
    #
    # "click .blue-move": ->
    #   console.log "adding move to game #{@_id}"
    #   Meteor.call "createMove", @_id, "Blue player makes a move"
    #
    # "click .red-move": ->
    #   console.log "adding move to game #{@_id}"
    #   Meteor.call "createMove", @_id, "Red player makes a move"
    #
    # "change .select-character": (event) ->
    #   select = $(event.target)
    #   team = select.closest(".team").data("team")
    #   slot = select.data("slot")
    #   characterID = select.val()
    #   gameID = select.closest(".game").attr("id")
    #
    #   Meteor.call "setCharacterSlot", gameID, characterID, slot, team
    #
    #   console.log "setting character #{characterID} in game #{gameID}"

  #
  # Character

  Template.character.helpers

  Template.character.events

    # "click .character": (event) ->
    #   character = $(event.target).closest(".character")
    #   otherCharacters = $(".character").not(character)
    #   controls = $(".character-controls")
    #
    #   otherCharacters.removeClass("selected")
    #
    #   if character.hasClass "selected"
    #     character.removeClass "selected"
    #     controls.removeClass("active")
    #   else
    #     character.addClass "selected"
    #     controls
    #       .attr { "data-x-pos": character.attr("data-x-pos"), "data-y-pos": character.attr("data-y-pos") }
    #       .addClass("active")

  Template.character.onRendered ->
    # self = this
    # slot = self.data.slot
    # team = self.data.team
    # character = self.$(".character")
    #
    # # Set initial positions
    # switch slot
    #   when 1
    #     switch team
    #       when 1
    #         xPos = 1
    #         yPos = 1
    #       when 2
    #         xPos = Game.colCount
    #         yPos = Game.rowCount
    #   when 2
    #     switch team
    #       when 1
    #         xPos = 1
    #         yPos = 2
    #       when 2
    #         xPos = Game.colCount
    #         yPos = Game.rowCount-1
    #   when 3
    #     switch team
    #       when 1
    #         xPos = 1
    #         yPos = 3
    #       when 2
    #         xPos = Game.colCount
    #         yPos = Game.rowCount-2
    #   when 4
    #     switch team
    #       when 1
    #         xPos = 1
    #         yPos = 4
    #       when 2
    #         xPos = Game.colCount
    #         yPos = Game.rowCount-3
    #
    # character.attr { "data-x-pos": xPos, "data-y-pos": yPos }

  #
  # Character controls

  Template.characterControls.helpers

  Template.characterControls.events

    # "click .move": (event) ->
    #   button = $(event.target)
    #   buttonX = button.attr("data-move-x")
    #   buttonY = button.attr("data-move-y")
    #   moveX = 0
    #   moveY = 0
    #
    #   if buttonX
    #     moveX = +buttonX
    #   if buttonY
    #     moveY = +buttonY
    #
    #   moveCharacter(moveX, moveY)

#
# Server

if Meteor.isServer
  Meteor.startup ->

    #
    # Character setup

    # Characters.remove({})
    #
    # characterMap = [
    #   {
    #     name: "Cleric"
    #   }
    #   {
    #     name: "Rogue"
    #   }
    #   {
    #     name: "Warrior"
    #   }
    #   {
    #     name: "Wizard"
    #   }
    # ]
    #
    # for key, character of characterMap
    #   Characters.insert
    #     name: character.name

  #
  # Methods on the server

  Meteor.methods

    # setCharacterSlot: (gameID, characterID, slot, team) ->
    #   slotID = "#{team}.#{slot}"
    #   console.log "slotID is #{slotID}"
    #
    #   Games.update {
    #     _id: gameID
    #     "characters.slotID": slotID
    #   }, $set:
    #     "characters.$.characterID": characterID
    #
    # createGame: ->
    #   Games.insert
    #     createdAt: new Date()
    #     started: false
    #     turn: 0
    #     moves: 0
    #     characters: [
    #       {
    #         slotID: "1.1"
    #         team: 1
    #         slot: 1
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "1.2"
    #         team: 1
    #         slot: 2
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "1.3"
    #         team: 1
    #         slot: 3
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "1.4"
    #         team: 1
    #         slot: 4
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: true
    #       }
    #       {
    #         slotID: "2.1"
    #         team: 2
    #         slot: 1
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "2.2"
    #         team: 2
    #         slot: 2
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "2.3"
    #         team: 2
    #         slot: 3
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #       {
    #         slotID: "2.4"
    #         team: 2
    #         slot: 4
    #         characterID: false
    #         movesLeft: Game.movesPerCharacter
    #         downed: false
    #       }
    #     ]
    #     # , (error, results) ->
    #       # Meteor.call "routeToGame", results
    #
    # startGame: (gameID) ->
    #   Games.update gameID,
    #     $set:
    #       started: true
    #       turn: 1
    #
    # stopGame: (gameID) ->
    #   Games.update gameID,
    #     $set:
    #       started: false
    #
    # endTurn: (gameID) ->
    #   #  TODO: can't use multi
    #   # Games.update {
    #   #   _id: gameID
    #   #   "characters.team":
    #   #     $gt: 0
    #   # }, { $set: "characters.$.movesLeft": Game.movesPerCharacter }, multi: true,
    #   #   (error, results) ->
    #   #     console.log "ending turn for team 1"
    #   #     console.log results
    #
    # createMove: (gameID, slotID, newX, newY, description) ->
    #   characterRecord = Games.findOne {
    #     _id: gameID
    #     "characters.slotID": slotID
    #   }, fields: {"characters.$.movesLeft": 1}
    #
    #   currentMoves = characterRecord.characters[0].movesLeft
    #
    #   if currentMoves == 0
    #     return
    #   else
    #     newMoves = currentMoves - 1
    #
    #     Games.update {
    #       _id: gameID
    #       "characters.slotID": slotID
    #     }, $set:
    #       "characters.$.movesLeft": newMoves
    #
    #     Moves.insert
    #       createdAt: new Date()
    #       gameID: gameID
    #       description: description
    #       slotID: slotID
    #       type: "move"
    #       targets:
    #         [x: newX, y: newY]
