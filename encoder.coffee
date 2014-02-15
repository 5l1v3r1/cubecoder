Permutation = require './permutation'
{cornerOrientation, edgeOrientation} = require 'node-cuboids'
bigint = require 'bigint'

encodeCornerOrientations = (cuboid) ->
  # TODO: validate corner orientations
  # encode corner orientations as base 3
  flags = 0
  coefficient = 1
  for i in [0...7]
    corner = cuboid.getCorner i
    orientation = cornerOrientation corner.symmetry, 0
    flags += orientation * coefficient
    coefficient *= 3
  return flags

encodeEdgeOrientations = (cuboid) ->
  flags = 0
  for i in [0...11]
    edge = cuboid.getEdge i
    orientation = edgeOrientation edge, i, 2
    flags |= (!orientation << i)
  return flags

encodeEdgePerms = (cuboid) ->
  permValues = []
  for i in [0...12]
    edge = cuboid.getEdge i
    permValues[i] = edge.dedgeIndex
  return (new Permutation permValues).index()

encodeCornerPerms = (cuboid) ->
  permValues = []
  for i in [0...8]
    corner = cuboid.getCorner i
    permValues[i] = corner.index
  return (new Permutation permValues).index()

encodeCornerPermsNoParity = (cuboid) ->
  permValues = []
  for i in [0...8]
    corner = cuboid.getCorner i
    permValues[i] = corner.index
  return (new Permutation permValues).indexAssumingParity()

module.exports = (cuboid) ->
  co = encodeCornerOrientations cuboid
  eo = encodeEdgeOrientations cuboid
  ep = encodeEdgePerms cuboid
  cp = encodeCornerPerms cuboid
  cpnp = encodeCornerPermsNoParity cuboid
  
  coCount = Math.pow 3, 7
  eoCount = Math.pow 2, 11
  epCount = 12*11*10*9*8*7*6*5*4*3*2
  
  number = bigint co + coCount * eo
  number = number.add bigint(coCount).mul(eoCount).mul ep
  number = number.add bigint(coCount).mul(eoCount).mul(epCount).mul cpnp
  hash = number.toString()
  
  return co: co, eo: eo, ep: ep, cp: cp, cpnp: cpnp, hash: hash
