extends Control

func _ready():
	# Connect the buttons to the relevant functions.
	$But11.connect("pressed", Callable(self, "_on_11_pressed"))
	$But12.connect("pressed", Callable(self, "_on_12_pressed"))
	$But13.connect("pressed", Callable(self, "_on_13_pressed"))
	$But14.connect("pressed", Callable(self, "_on_14_pressed"))
	$ButHS.connect("pressed", Callable(self, "_on_HS_pressed"))
	showMedals()

func _on_11_pressed():
	get_tree().change_scene_to_file("res://1-1.tscn")
	
func _on_12_pressed():
	get_tree().change_scene_to_file("res://1-2.tscn")

func _on_13_pressed():
	get_tree().change_scene_to_file("res://1-3.tscn")
	
func _on_14_pressed():
	get_tree().change_scene_to_file("res://1-4.tscn")

func _on_HS_pressed():
	get_tree().change_scene_to_file("res://high_scores.tscn")

func _on_QuitButton_pressed():
	# Quit the game.
	get_tree().quit()

func showMedals():
	# Stage 1
	if Globals.medals["1"] > 0: $OneMedalB.show()
	if Globals.medals["1"] > 1: $OneMedalS.show()
	if Globals.medals["1"] > 2: $OneMedalG.show()
	if Globals.medals["1"] > 3: $OneMedalA.show()
	
	# Stage 2
	if Globals.medals["2"] > 0: $TwoMedalB.show()
	if Globals.medals["2"] > 1: $TwoMedalS.show()
	if Globals.medals["2"] > 2: $TwoMedalG.show()
	if Globals.medals["2"] > 3: $TwoMedalA.show()
	
	# Stage 3
	if Globals.medals["3"] > 0: $ThreeMedalB.show()
	if Globals.medals["3"] > 1: $ThreeMedalS.show()
	if Globals.medals["3"] > 2: $ThreeMedalG.show()
	if Globals.medals["3"] > 3: $ThreeMedalA.show()
	
	# Stage 4
	if Globals.medals["4"] > 0: $FourMedalB.show()
	if Globals.medals["4"] > 1: $FourMedalS.show()
	if Globals.medals["4"] > 2: $FourMedalG.show()
	if Globals.medals["4"] > 3: $FourMedalA.show()
