{StickerMap} = require 'node-cuboids'

parseRubiksString = (str) ->
  return null if str.length isnt 54
  for c in str
    return null if not c in [1..6].join ''
  map = new StickerMap 3, 3, 3
  for s, i in str
    map.setSticker i, parseInt s
  try
    return map.getCuboid()
  catch e
    console.log e
    return null

module.exports =
  parseRubiksString: parseRubiksString

