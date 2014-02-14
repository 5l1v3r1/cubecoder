class Permutation
  constructor: (@resultant) ->

  compare: (perm) ->
    if perm.resultant.length isnt @resultant.length
      throw new RangeError 'dimensions do not match'
    for x, i in @resultant
      return -1 if perm.resultant[i] > x
      return 1 if perms.resultant[i] < x
    return 0
  
  @_allPermsLoop: (prefix, remaining) ->
    if remaining.length is 0
      return new Permutation prefix
    list = []
    for x, i in remaining
      newRemaining = (x for x in remaining)
      newRemaining.splice i, 1
      newPrefix = prefix.concat x
      list.push x for x in @_allPermsLoop newPrefix, newRemaining
    return list

  @allPermutations: (len) -> @allPermsLoop [], [0...len]


class PermPool
  constructor: (@list) ->

  indexOf: (permutation) ->
    [low, high] = [-1, @list.length]
    while high - low > 1
      mid = Math.floor (low + high) / 2
      val = @list[mid]
      result = val.compare permutation
      high = mid if result is 1
      low = mid if result is -1
      return mid if result is 0
    index = Math.floor (low + high) / 2
    return -1 if index < 0
    return -1 if @list[index].compare(permutation) isnt 0
    return index


module.exports =
  Permutation: Permutation
  PermPool: PermPool

