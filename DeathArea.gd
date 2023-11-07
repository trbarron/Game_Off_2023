extends Area3D

signal character_died

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "character":
		print("Character has diedasdf")
		emit_signal("character_died")
