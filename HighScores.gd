extends Control

@onready var postScoreRequest = $getScoresHTTPRequest
@onready var grid = $HighScoreViewer
var stage = 1

func _ready():
	# Connect the buttons to the relevant functions.
	$ButBack.connect("pressed", Callable(self, "_on_back_pressed"))
	$ButPrev.connect("pressed", Callable(self, "_on_prev_pressed"))
	$ButNext.connect("pressed", Callable(self, "_on_next_pressed"))
	setStageName()
	postScoreRequest.request_completed.connect(_on_request_completed)
	getScores(stage)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://main_menu_scene.tscn")

func clearGridContainer(gridContainer):
	for child in gridContainer.get_children():
		child.queue_free()

func getScores(stage):
	# Kill all the younglings at the start
	clearGridContainer(grid)
	
	var url = "https://qse3b041vg.execute-api.us-west-2.amazonaws.com/stage1/sz/getScores?stage=" + str(stage)
	# Prepare the HTTP request
	postScoreRequest.request(url)

func setStageName():
	$StageName.text = "Stage: " + str(stage)

func _on_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print("HTTP request failed with code: ", response_code)
		return

	var resp = JSON.parse_string(body.get_string_from_utf8())

	# Extract data and form a new array
	var playersData = []
	var rank = 1
	for player in resp:
		var playerInfo = {
			"name": player["name"],
			"rank": rank,
			"time": player["time"]
		}
		playersData.append(playerInfo)
		rank += 1
	populateGrid(playersData)

func populateGrid(items):
	$Loading.hide()
	grid.columns = 3
	for item in items:
		var nameLabel = Label.new()
		nameLabel.text = item.name
		grid.add_child(nameLabel)

		var rankLabel = Label.new()
		rankLabel.text = str(item.rank)
		grid.add_child(rankLabel)

		var timeLabel = Label.new()
		timeLabel.text = str(item.time)
		grid.add_child(timeLabel)

func _on_next_pressed():
	$Loading.show()
	$ButNext.hide()
	stage += 1
	if stage > 4: stage = 1
	getScores(stage)
	setStageName()
	$ButNext.show()

func _on_prev_pressed():
	$Loading.show()
	$ButPrev.hide()
	stage -= 1
	if stage < 1: stage = 4
	getScores(stage)
	setStageName()
	$ButPrev.show()
