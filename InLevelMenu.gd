extends Control

@onready var inLevelMenu = $SubViewportContainer/SubViewport/InLevelMenu
@onready var characterNode = get_node("../character")

# Called when the node enters the scene tree for the first time.
func _ready():
	var deathArea = get_node("../DeathArea")
	deathArea.connect("character_died", Callable(self, "_on_character_died"))
	var goalArea = get_node("../GoalArea")
	goalArea.connect("character_won", Callable(self, "_on_character_won"))
	
	$ButMainMenu.connect("pressed", Callable(self, "_on_MainMenu_pressed"))
	$ButRestart.connect("pressed", Callable(self, "_on_Restart_pressed"))

func _on_character_died():
	show()

func _on_character_won():
	var charTime = characterNode.time
	inLevelMenu.text = "You won in " + str(round(charTime * 100.0) / 100.0) + " seconds!"
	show()

func _on_Restart_pressed():
	var current_scene_name = get_tree().current_scene.name
	get_tree().change_scene_to_file("res://" + current_scene_name + ".tscn")
	
func _on_MainMenu_pressed():
	get_tree().change_scene_to_file("res://main_menu_scene.tscn")

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE or event.keycode == KEY_P:
			inLevelMenu.text = "Pause"
			if !self.is_visible():
				show()
				characterNode.startAction = false
			else:
				hide()
				characterNode.startAction = true
