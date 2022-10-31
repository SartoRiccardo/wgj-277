extends "res://ui/HoverableButton.gd"

var light_offset := Vector2(21, 0)
var dark_offset := Vector2(11, 0)

func _on_hover() -> void:
	icon.region.position = light_offset

func _on_unhover() -> void:
	icon.region.position = dark_offset

func _on_btn_down() -> void:
	icon.region.position = light_offset

func _on_btn_up() -> void:
	icon.region.position = light_offset if is_hovered() else dark_offset
