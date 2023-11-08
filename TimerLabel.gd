extends Control

func _ready():
	var deathArea = get_node("../DeathArea")
	deathArea.connect("character_died", Callable(self, "_on_character_died"))
	var goalArea = get_node("../GoalArea")
	goalArea.connect("character_won", Callable(self, "_on_character_won"))

func _on_character_died():
	hide()

func _on_character_won():
	hide()
