extends Control

func _ready():
	# Connect the buttons to the relevant functions.
	$But11.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	
func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://1-1.tscn")


func _on_QuitButton_pressed():
	# Quit the game.
	get_tree().quit()
