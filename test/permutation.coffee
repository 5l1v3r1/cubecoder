Permutation = require '../permutation'

testIndexing = ->
  for i in [0...120]
    if Permutation.withIndex(i, 5).index() isnt i
      console.log 'withIndex() -> index() invalid for', i, ',', 5

testParity = ->
  for i in [0...120]
    p = Permutation.withIndex i, 5
    pi = p.indexAssumingParity()
    newP = Permutation.withIndexAssumingParity pi, 5, p.parity()
    if not newP.equals p
      console.log 'indexAssumingParity() -> withIndexAssumingParity() invalid for', i, ',', 5, 'pi:', pi

testIndexing()
testParity()
