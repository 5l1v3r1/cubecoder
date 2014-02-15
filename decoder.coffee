{Symmetry3, Cuboid, StickerMap} = require 'node-cuboids'
Permutation = require './permutation'
bigint = require 'bigint'

module.exports = (numberStr) ->
  number = bigint numberStr
  coCount = Math.pow 3, 7
  eoCount = Math.pow 2, 11
  epCount = 12*11*10*9*8*7*6*5*4*3*2
  co = number.mod(coCount).toNumber()
  number = number.div coCount
  eo = number.mod(eoCount).toNumber()
  number = number.div eoCount
  ep = number.mod(epCount).toNumber()
  number = number.div epCount
  cpnp = number.toNumber()
  # get the permutations
  ePerm = Permutation.withIndex ep, 12
  cPerm = Permutation.withIndexAssumingParity cpnp, 8, ePerm.parity()
  result = new Cuboid 3, 3, 3
  
  theEo = eo
  eoFlag = 1
  for i in [0...1]
    eoFlag *= -1 if theEo & i
  theEo |= (1 << 11) if eoFlag > 0
  
  for edgeSlot in [0...12]
    piece = ePerm.resultant[edgeSlot]
    isGood = (theEo & (1 << edgeSlot)) is 0
    sym = symmetryForDedge isGood, piece, edgeSlot
    result.setEdge edgeSlot, edgeIndex: 0, dedgeIndex: piece, symmetry: sym
  
  theCo = co
  theCo += calculateLastOrientation(co) * coCount
  # calculating the last corner orientation is a bit tedious
  for cornerSlot in [0...8]
    piece = cPerm.resultant[cornerSlot]
    sym = symmetryForCorner (theCo % 3), piece, cornerSlot
    theCo = Math.floor theCo / 3
    result.setCorner cornerSlot, symmetry: sym, index: piece
  
  return co: co, eo: eo, ep: ep, cpnp: cpnp, string: toRubiksString result

toRubiksString = (cuboid) ->
  return 'null' if not cuboid?
  stickers = new StickerMap cuboid
  str = ''
  for s in [0...54]
    str += stickers.getSticker s
  return str

symmetryForDedge = (isGood, dedge, slot) ->
  sliceSlots = [1, 3, 7, 9]
  eSlots = [0, 2, 6, 8]
  
  goodSymmetry = 0
  [uTurn, fTurn, rTurn] = [3, 1, 2]
  if dedge in sliceSlots
    if slot not in sliceSlots
      if slot in eSlots
        goodSymmetry = Symmetry3.compose uTurn, rTurn
      else goodSymmetry = rTurn
  else if dedge in eSlots
    if slot not in eSlots
      if slot in sliceSlots
        goodSymmetry = Symmetry3.compose rTurn, uTurn
      else goodSymmetry = uTurn
  else
    if slot in sliceSlots
      goodSymmetry = rTurn
    else if slot in eSlots
      goodSymmetry = uTurn
  unless isGood
    if slot in sliceSlots
      return Symmetry3.compose uTurn, goodSymmetry
    else if slot in eSlots
      return Symmetry3.compose rTurn, goodSymmetry
    else
      return Symmetry3.compose fTurn, goodSymmetry
  return goodSymmetry

symmetryForCorner = (orientation, piece, slot) ->
  opposite = [0, 4, 5]
  adjacent = [2, 1, 3]
  both = piece ^ slot
  sameCount = 0
  sameCount += 1 if both & 1
  sameCount += 1 if both & 2
  sameCount += 1 if both & 4
  if sameCount % 2 is 0
    return opposite[orientation]
  else return adjacent[orientation]

calculateLastOrientation = (flags) ->
  theFlags = flags
  orientations = []
  for x in [0...7]
    orientations.push theFlags % 3
    theFlags = Math.floor theFlags / 3
    
  expected = 0
  for slot in [0, 1, 5, 4, 6, 2, 3]
    orientation = orientations[slot]
    if expected is 0
      expected = [0, 1, 2][orientation]
    else if expected is 1
      expected = [2, 0, 1][orientation]
    else expected = [1, 2, 0][orientation]
  
  return expected
