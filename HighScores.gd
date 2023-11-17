extends Control

@onready var postScoreRequest = $getScoresHTTPRequest

func _ready():
	# Connect the buttons to the relevant functions.
	$ButBack.connect("pressed", Callable(self, "_on_back_pressed"))
	postScoreRequest.request_completed.connect(_on_request_completed)
	getScores(1)
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu_scene.tscn")
	
func getScores(stage):
	var url = "https://qse3b041vg.execute-api.us-west-2.amazonaws.com/stage1/sz/getScores?stage=" + str(stage)

	print(url)

	# Prepare the HTTP request
	postScoreRequest.request(url)

func _on_request_completed(result, response_code, headers, body):
	
	if response_code != 200:
		print("HTTP request failed with code: ", response_code)
		return
		
	print("got resp")
	var resp = JSON.parse_string(body.get_string_from_utf8())
	
	print(resp)

	# Parse the JSON response
	var json = JSON.new()
	var parsed = json.parse(resp)
	if parsed.error != OK:
		print("Failed to parse JSON: ", parsed.error_string)
		return

	# Extract data and form a new array
	var playersData = []
	var rank = 1
	for player in parsed.result:
		var playerInfo = {
			"name": player["name"],
			"rank": rank,
			"time": player["time"]
		}
		playersData.append(playerInfo)
		rank += 1

	# Print or return the result
	print(playersData)
