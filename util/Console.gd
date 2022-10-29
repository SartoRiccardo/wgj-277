extends Node

var permanent = ""

func _process(_d) -> void:
	$MarginContainer/PanelContainer/Label.text = permanent

func writeln(data, permanent=false) -> void:
	if permanent:
		permanent += str(data) + "\n"
	else:
		$MarginContainer/PanelContainer/Label.text += str(data) + "\n"
