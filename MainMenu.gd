extends Control

func _ready():
	# Connect the buttons to the relevant functions.
	$But11.connect("pressed", Callable(self, "_on_11_pressed"))
	$But12.connect("pressed", Callable(self, "_on_12_pressed"))
	$But13.connect("pressed", Callable(self, "_on_13_pressed"))		

func _on_11_pressed():
	get_tree().change_scene_to_file("res://1-1.tscn")
	
func _on_12_pressed():
	get_tree().change_scene_to_file("res://1-2.tscn")

func _on_13_pressed():
	get_tree().change_scene_to_file("res://1-3.tscn")


func _on_QuitButton_pressed():
	# Quit the game.
	get_tree().quit()
