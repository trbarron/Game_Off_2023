extends Area3D

signal character_won

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "character":
		print("Character has won")
		emit_signal("character_won")
