extends HTTPRequest
class_name ProfanityFilter

var profanity_list_file := 'res://Resources/PhraseFiles/en/profanity_encoded.txt'
var profanity_list := []
var is_clean := false

func _ready():
  _load_profanity_list()
  request_completed.connect(_on_request_completed)

func _load_profanity_list():
  var profanity_file = FileAccess.open(profanity_list_file, FileAccess.READ)
  var encoded_contents = profanity_file.get_as_text()
  var decoded_contents = encoded_contents.hex_decode().get_string_from_utf8()
  for line in decoded_contents.split("\n"):
    profanity_list.append(line)

func _replace_l33t(player_name: String):
  var l33t: Dictionary = {
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
      new_name = new_name.replace(replacement, letter)
  return new_name

func is_name_ok(player_name: String):
  player_name = _replace_l33t(player_name)
  for profanity in profanity_list:
    if player_name.contains(profanity):
      return false
  return true

func _on_request_completed(_result, _response_code, _headers, body):
  var response = JSON.parse_string(body.get_string_from_utf8())
  print(response)
  is_clean = !response.isProfanity
