extends HTTPRequest
class_name ProfanityFilter

var profanity_filter_url := 'https://vector.profanity.dev'
var is_clean := false

func _ready():
  request_completed.connect(_on_request_completed)

func _replace_l33t(player_name: String):
  var l33t = {
    'a': ['4', '@'],
    'b': ['8'],
    'e': ['3'],
    'g': ['6'],
    'i': ['1', '!'],
    'o': ['0'],
    's': ['5', '$'],
    't': ['7']
  }
  var new_name = player_name
  for letter in l33t:
    for replacement in l33t[letter]:
      new_name = new_name.replace(letter, replacement)
  return new_name

func is_name_ok(player_name: String):
  # replace l33t speak with regular letters
  player_name = _replace_l33t(player_name)
  # this api requires at least 2 words 🤷‍♂️
  player_name = player_name + " " + player_name
  request(
    profanity_filter_url,
    [ 'Content-Type: application/json'],
    HTTPClient.METHOD_POST,
    JSON.stringify({ 'message': player_name })
    )
  await request_completed
  return is_clean

func _on_request_completed(_result, _response_code, _headers, body):
  var response = JSON.parse_string(body.get_string_from_utf8())
  print(response)
  is_clean = !response.isProfanity
