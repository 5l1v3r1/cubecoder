if process.argv.length isnt 3
  console.log 'Usage: coffee server.coffee <port>'
  process.exit()

port = parseInt process.argv[2]
if isNaN port
  console.log 'invalid port:', port
  process.exit()

express = require 'express'
{parseRubiksString} = require './parser'
encodeRubiksCube = require './encoder'
app = express()

app.get '/encode', (req, res) ->
  if typeof req.query.stickers isnt 'string'
    return res.json error: 'missing `stickers` arguments'
  if not cuboid = parseRubiksString req.query.stickers
    return res.json error: 'invalid cuboid data'
  if not codes = encodeRubiksCube cuboid
    return res.json error: 'failed to encode cuboid'
  return res.json codes

app.listen port
