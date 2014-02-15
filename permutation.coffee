factorial = [0, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600]
factorialHalf = [0, 0, 1, 3, 12, 60, 360, 2520, 20160, 181440, 1814400, 19958400, 239500800]

class Permutation
  constructor: (@resultant) ->

  compare: (perm) ->
    if perm.resultant.length isnt @resultant.length
      throw new RangeError 'dimensions do not match'
    for x, i in @resultant
      return -1 if perm.resultant[i] > x
      return 1 if perms.resultant[i] < x
    return 0
  
  isIdentity: ->
    for x, i in @resultant
      return false if x isnt i
    return true
  
  equals: (perm) ->
    return false if perm.resultant.length isnt @resultant.length
    for x, i in perm.resultant
      return false if x isnt @resultant[i]
    return true
  
  parity: ->
    result = 1
    temp = @copy()
    for i in [0...@resultant.length]
      continue if temp.resultant[i] is i
      result *= -1
      for x in [i + 1...@resultant.length]
        if temp.resultant[x] is i
          [temp.resultant[x], temp.resultant[i]] = [temp.resultant[i], i]
          break
    return result
  
  copy: -> new Permutation @resultant.slice 0
  
  tail: ->
    first = @resultant[0]
    newList = []
    for x in @resultant[1..]
      if x > first then newList.push x - 1
      else newList.push x
    return new Permutation newList
  
  index: ->
    return 0 if @resultant.length is 1
    nextLen = @tail().index()
    return @resultant[0] * factorial[@resultant.length - 1] + nextLen

  indexAssumingParity: ->
    return 0 if @resultant.length <= 2
    nextLen = @tail().indexAssumingParity()
    return @resultant[0] * factorialHalf[@resultant.length - 1] + nextLen

  @withIndex: (index, len) ->
    return new Permutation [0] if len is 1
    prefix = Math.floor index / factorial[len - 1]
    cutOff = prefix * factorial[len - 1]
    remaining = @withIndex(index - cutOff, len - 1).resultant
    remOff = ((if x < prefix then x else x + 1) for x in remaining)
    return new Permutation [prefix].concat remOff
  
  @withIndexAssumingParity: (index, len, parity) ->
    return [0] if len is 1
    if len is 2
      return new Permutation [0, 1] if parity > 0
      return new Permutation [1, 0]
    prefix = Math.floor index / factorialHalf[len - 1]
    cutOff = prefix * factorialHalf[len - 1]
    remaining = @withIndexAssumingParity(index - cutOff, len - 1).resultant
    remOff = ((if x < prefix then x else x + 1) for x in remaining)
    result = new Permutation [prefix].concat remOff
    if result.parity() isnt parity
      list = result.resultant
      [list[len - 1], list[len - 2]] = [list[len - 2], list[len - 1]]
    return result


module.exports = Permutation
