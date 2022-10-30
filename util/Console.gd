extends Node

var permanent_text = ""

func _process(_d) -> void:
	$MarginContainer/PanelContainer/Label.text = permanent_text

func writeln(data, permanent=false) -> void:
	if permanent:
		permanent_text += str(data) + "\n"
	else:
		$MarginContainer/PanelContainer/Label.text += str(data) + "\n"
