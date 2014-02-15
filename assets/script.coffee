window.encodeCube = ->
  fields = ['front', 'back', 'top', 'bottom', 'right', 'left']
  data = ''
  for field in fields
    data += $('#face_' + field).val()
  urlComp = encodeURIComponent data
  url = location.pathname + 'encode?stickers=' + urlComp
  $.getJSON url, (data) ->
    $('button').prop 'disabled', false
    return alert 'Error: ' + data.error if data.error?
    $('#input_number').val data.hash
    printMetadata 'Encode', data
  $('button').prop 'disabled', true

window.decodeCube = ->
  $('button').prop 'disabled', true
  urlComp = encodeURIComponent $('#input_number').val()
  url = location.pathname + 'decode?number=' + urlComp
  $.getJSON url, (data) ->
    $('button').prop 'disabled', false
    return alert 'Error: ' + data.error if data.error?
    string = data.string
    fields = ['front', 'back', 'top', 'bottom', 'right', 'left']
    for x in fields
      $('#face_' + x).val string[...9]
      string = string[9..]
    printMetadata 'Decode', data

printMetadata = (operation, obj) ->
  str = JSON.stringify obj, null, 2
  preEl = $ '<pre />'
  preEl.text str
  $('#metadata').html '<h2>' + operation + ' Metadata</h1>'
  $('#metadata').append preEl
