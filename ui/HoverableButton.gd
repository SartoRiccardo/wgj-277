extends Button

func _ready() -> void:
	connect("mouse_entered", self, "_on_hover")
	connect("mouse_exited", self, "_on_unhover")
	connect("button_down", self, "_on_btn_down")
	connect("button_up", self, "_on_btn_up")

func _on_hover() -> void:
	pass

func _on_unhover() -> void:
	pass

func _on_btn_down() -> void:
	pass

func _on_btn_up() -> void:
	pass
