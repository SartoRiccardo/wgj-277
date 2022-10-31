extends MarginContainer

func _ready() -> void:
	$HBox1/PauseBtn.connect("pressed", self, "_on_pause")

func _on_pause() -> void:
	pass
