#
# Globals

Game = {}
# Game.rowCount = 8
# Game.colCount = 13
Game.fleetID = false
# Game.movesPerCharacter = 2
# Game.fleetsPerTeam = 4

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

Router.route "/:_id",
  template: "game"
  name: "game"
  data: ->
    targetFleet = Fleets.findOne _id: @.params._id
    if targetFleet
      console.log targetFleet
      Game.fleetID = @.params._id
      return targetFleet
    else
      return false

#
# Client

if Meteor.isClient

  #
  # Non-Meteor methods

  # moveCharacter = (x, y) ->
  #   fleet = $(".fleet.selected")
  #   slotID = character.attr("data-slotID")
  #   xPos = +fleet.attr("data-x-pos")
  #   yPos = +fleet.attr("data-y-pos")
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
  #     fleet.attr( {"data-x-pos": newX, "data-y-pos": newY} )

  #
  # Methods on the client

  Meteor.methods
    routeToFleet: (fleetID) ->
      Router.go "fleet", _id: fleetID

  #
  # Layout

  Template.layout.helpers


  Template.layout.events


  #
  # Home

  Template.home.helpers
    fleets: ->
      console.log "getting all fleets"
      return Fleets.find({}, {sort: {createdAt: -1}})

    # characters: ->
    #   console.log "getting all characters"
    #   return Characters.find({})

  Template.home.events
    "click .start-fleet": ->
      console.log "starting a fleet"
      Meteor.call "startFleet"


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
    #   shipID = select.val()
    #   gameID = select.closest(".game").attr("id")
    #
    #   Meteor.call "setCharacterSlot", gameID, shipID, slot, team
    #
    #   console.log "setting character #{shipID} in game #{gameID}"

  #
  # Fleet

  Template.fleet.helpers

  Template.fleet.events

    "click .fleet": (event) ->
      fleet = $(event.target).closest(".fleet")
      otherFleets = $(".fleet").not(fleet)
      controls = $(".fleet-controls")

      otherFleets.removeClass("selected")

      if fleet.hasClass "selected"
        fleet.removeClass "selected"
        controls.removeClass "active"
      else
        fleet.addClass "selected"
        controls
          .attr { "data-x-pos": fleet.attr("data-x-pos"), "data-y-pos": fleet.attr("data-y-pos") }
          .addClass("active")

  # Template.fleet.onRendered ->
    # self = this
    # slot = self.data.slot
    # team = self.data.team
    # character = self.$(".fleet")
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

  Template.fleetControls.helpers

  Template.fleetControls.events

    "click .move": (event) ->
      button = $(event.target)
      buttonX = button.attr("data-move-x")
      buttonY = button.attr("data-move-y")
      moveX = 0
      moveY = 0

      if buttonX
        moveX = +buttonX
      if buttonY
        moveY = +buttonY

      Meteor.call "moveFleet", Game.fleetID, moveX, moveY

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

    # setCharacterSlot: (gameID, shipID, slot, team) ->
    #   slotID = "#{team}.#{slot}"
    #   console.log "slotID is #{slotID}"
    #
    #   Games.update {
    #     _id: gameID
    #     "characters.slotID": slotID
    #   }, $set:
    #     "characters.$.fleetID": shipID

    startFleet: ->
      Fleets.insert
        createdAt: new Date()
        xPos: 0
        yPos: 0
        ships: [
          {
            slot: 1
            shipID: false
          }
          {
            slot: 2
            shipID: false
          }
          {
            slot: 3
            shipID: false
          }
          {
            slot: 4
            shipID: false
          }
          {
            slot: 1
            shipID: false
          }
          {
            slot: 2
            shipID: false
          }
          {
            slot: 3
            shipID: false
          }
          {
            slot: 4
            shipID: false
          }
        ]
        # , (error, results) ->
        #   console.log results
        #   console.log error

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

    moveFleet: (fleetID, moveX, moveY) ->
      # console.log "fleet #{fleetID} moving by #{moveX},#{moveY}"
      Fleets.update fleetID,
        $inc:
          xPos: moveX
          yPos: moveY
