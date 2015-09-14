#
# Globals

Game = {}
Game.fleetID = false
Game.yPos = 0
Game.xPos = 0
Game.starSpeed = 0.5
Game.starStep  = 1
Game.starStep1 = 2
Game.starStep2 = 3

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
      Game.xPos = targetFleet.xPos
      Game.yPos = targetFleet.yPos
      return targetFleet
    else
      return false

#
# Client

if Meteor.isClient

  #
  # Non-Meteor methods

  moveBackdrop = (number) ->
    xPos = Game.xPos * number
    yPos = Game.yPos * number
    xPosRounded = Math.ceil(xPos / 100)
    yPosRounded = Math.ceil(yPos / 100)

    transform = "transform: translate( #{-xPos}vw, #{-yPos}vh );"
    left = ""
    top = ""

    if xPos > 100
      left = "left: #{ 100*xPosRounded - 100 }vw;"
    if xPos < -100
      left = "left: #{ 100*xPosRounded }vw;"
    if yPos > 100
      top =   "top: #{ 100*yPosRounded - 100 }vh;"
    if yPos < -100
      top =   "top: #{ 100*yPosRounded }vh;"

    style = transform + left + top

    return {
      style: style
    }

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


  Template.header.events
    "click .start-fleet": ->
      console.log "starting a fleet"
      Meteor.call "startFleet", (error, results) ->
        if error
          console.log error
        else
          Router.go "/" + results


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
  # Backdrop

  Template.backdrop.helpers
    layer1: ->
      moveBackdrop( Game.starSpeed * Game.starStep )
    layer2: ->
      moveBackdrop( Game.starSpeed * Game.starStep1 )
    layer3: ->
      moveBackdrop( Game.starSpeed * Game.starStep2 )

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

  Template.otherFleets.helpers

    otherFleets: ->
      return Fleets.find({
        _id:
          $not: Game.fleetID
      }, {sort: {createdAt: -1}})

    offsetPositions: ->
      offsetX = @xPos - Game.xPos
      offsetY = @yPos - Game.yPos

      return {
        "style": "transform: translate3d(#{offsetX*100}%, #{offsetY*100}%, 0)"
      }

  #
  # Character controls

  Template.fleetControls.helpers

  Template.fleetControls.events

    "click .move": (event) ->
      event.stopPropagation()
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
