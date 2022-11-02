extends Node

signal step_end

export (String, MULTILINE) var text
export (float) var time_before_cleanup := 0.0
export (float) var time_before_next := 2.0

var has_ended := false

func enter(label : TutorialUI):
	label.change_text(text)

func cleanup() -> void:
	pass
