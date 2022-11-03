tool
extends Control
class_name TutorialUI

func _process(_delta) -> void:
	$Panel.rect_pivot_offset = $Panel.rect_size / 2.0

func change_text(text: String) -> void:
	$Panel/VBox/Margin/TutorialText.set_bbcode(text)
	$AnimationPlayer.play("wobble")

func show_play_button() -> void:
	$Panel/VBox/BtnPlay.show()
