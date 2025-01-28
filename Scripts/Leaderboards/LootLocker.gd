extends Leaderboard
class_name LootLocker

#@onready var submit_name_button: Button = %"submit_name_button"
#@onready var desired_name: TextEdit = %"desired_name"
#@onready var current_score_value: Label = %"current_score_value"
#@onready var high_score_value: Label = %"high_score_value"
#@onready var loading_panel: Panel = %"loading_panel"

var api_domain := "https://h38q7ajo.api.lootlocker.io/"
var domain_key := "h38q7ajo"
var game_key := "dev_47e6dd3fe47d475ab9fdfc365903bf44"

var session_token : String
var player_id : String
var player_short_id: String
var score: int = 0

var auth_http : HTTPRequest
var leader_http : HTTPRequest
var submit_score_http : HTTPRequest
var submit_name_http : HTTPRequest

func initialize():
	_authentication_request()

func _authentication_request():
	# Check if a player session exists
	var player_session_exists = false
	var file = FileAccess.open("user://LootLocker.data", FileAccess.READ)
	if file != null:
		player_id = file.get_as_text()
		file.close()
  
	if player_id != null and player_id.length() > 1:
		player_session_exists = true

	var data = {
		"game_key": game_key,
		"game_version": "0.0.1",
		"development_mode": true
	}

	if player_session_exists:
		data['player_identifier'] = player_id
  
	var headers = ['Content-Type: application/json']

	request_completed.connect(_on_auth_request_completed)
	request(api_domain + "game/v2/session/guest", headers, HTTPClient.METHOD_POST, JSON.stringify(data))

func _on_auth_request_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())

	# Save the player ID to file
	var file = FileAccess.open("user://LootLocker.data", FileAccess.WRITE)
	player_id = response.player_identifier
	player_short_id = str(response.player_id)
	file.store_string(player_id)
	file.close()

	# Save session token to memory
	session_token = response.session_token

	# Clear node
	request_completed.disconnect(_on_auth_request_completed)
	api_ready.emit()

func get_leaderboard_entry(board_id):
	leader_http = HTTPRequest.new()
	add_child(leader_http)
	var headers = [
		'Content-Type: application/json',
		'X-Session-Token: ' + session_token
	]
	var request_url = api_domain + "game/leaderboards/" + board_id + "/member/" + player_short_id
	print(request_url)
	leader_http.request_completed.connect(_on_get_leaderboard_entry_completed)
	leader_http.request(request_url, headers)

func _on_get_leaderboard_entry_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	#if response.score != null:
		#high_score_value.text = str(response.score)
	#else:
		#high_score_value.text = "0"
	leader_http.queue_free()

func get_leaderboard_entries(board_name: String):
	var headers = [
		'Content-Type: application/json',
		'X-Session-Token: ' + session_token
	]
	request_completed.connect(_on_get_leaderboards_completed)
	request(api_domain + "game/leaderboards/" + board_name + "/list", headers)

func _on_get_leaderboards_completed(_result, _responses_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	leaderboard_entries_retrieved.emit(response)
	print(response)
	request_completed.disconnect(_on_get_leaderboards_completed)

func upload_score(board_id: String, score: int):
	print('or the LL one?')
	var data = {
		"score": score
	}
	var headers = [
		'Content-Type: application/json',
		'X-Session-Token: ' + session_token
	]

	request_completed.connect(_on_submit_score_completed)
	request(api_domain + "game/leaderboards/" + board_id + "/submit", headers, HTTPClient.METHOD_POST, JSON.stringify(data))

func _on_submit_score_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	request_completed.disconnect(_on_submit_score_completed)
	upload_score_completed.emit()

func _update_score_label():
	pass
	#current_score_value.text = str(score)

func _submit_name():
	var name_check := ProfanityFilter.new()
	add_child(name_check)
	#var is_name_clean = name_check.is_name_ok(desired_name.text)
	var is_name_clean = true

	if !is_name_clean:
		print("Name contains profanity")
		return

	var data = {
		"name": 'desired_name.textt'
	}
	var headers = [
		'Content-Type: application/json',
		'X-Session-Token: ' + session_token
	]

	submit_name_http = HTTPRequest.new()
	add_child(submit_name_http)

	submit_name_http.request_completed.connect(_on_submit_name_completed)
	submit_name_http.request(api_domain + "game/player/name", headers, HTTPClient.METHOD_PATCH, JSON.stringify(data))

func _on_submit_name_completed(_result, _response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print(response)
	submit_name_http.queue_free()
