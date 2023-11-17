extends TextEdit

func _ready():
	self.text = Globals.globalUsername
	var callable = Callable(self, "_on_TextEdit_text_changed")
	connect("text_changed", callable)

func _on_TextEdit_text_changed():
	Globals.globalUsername = self.text
