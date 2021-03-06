#
# Globals

@Game = {}

Game.ySize = 21;
Game.xSize = 21;
Game.mapScale = 0.05

Game.halfX = Game.xSize * 2
Game.halfY = Game.ySize * 2
Game.mapHalfX = Game.halfX / Game.mapScale * 0.5
Game.mapHalfY = Game.halfX / Game.mapScale * 0.5

Game.coordinateMultiplier = 50
Game.galaxyBoundX = 180 * Game.coordinateMultiplier
Game.galaxyBoundY =  90 * Game.coordinateMultiplier

Game.starSpeed = 0.146
Game.starStep  = 1
Game.starStep1 = 2
Game.starStep2 = 3

Game.energyPerUnit = 10

Game.sinToDegrees = (sin) ->
  return Math.asin(sin) * 180/Math.PI

Game.hypotenuse = (a, b) ->
  return Math.sqrt(a*a + b*b)

Game.rightAngle = (a, b) ->
  c = Game.hypotenuse(a, b)
  sin = b/c
  return Game.sinToDegrees(sin)

Game.romanize = (num) ->
  if ! +num
    return false
  digits = String(+num).split('')
  key = [
    ''
    'C'
    'CC'
    'CCC'
    'CD'
    'D'
    'DC'
    'DCC'
    'DCCC'
    'CM'
    ''
    'X'
    'XX'
    'XXX'
    'XL'
    'L'
    'LX'
    'LXX'
    'LXXX'
    'XC'
    ''
    'I'
    'II'
    'III'
    'IV'
    'V'
    'VI'
    'VII'
    'VIII'
    'IX'
  ]
  roman = ''
  i = 3
  while i--
    roman = (key[+digits.pop() + i * 10] or '') + roman
  Array(+digits.join('') + 1).join('M') + roman
