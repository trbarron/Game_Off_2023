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
	var character_turns = characterNode.turns
	inLevelMenu.text = "You won in " + str(character_turns + 1) + " turns!"
	show()

func _on_Restart_pressed():
	get_tree().change_scene_to_file("res://main_menu_scene.tscn")
	
func _on_MainMenu_pressed():
	get_tree().change_scene_to_file("res://main_menu_scene.tscn")
