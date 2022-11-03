extends Node

var permanent_text = ""

func _ready():
	if OS.has_feature("release"):
		queue_free()

func _process(_d) -> void:
	$MarginContainer/PanelContainer/Label.text = permanent_text

func writeln(data, permanent=false) -> void:
	if permanent:
		permanent_text += str(data) + "\n"
	else:
		$MarginContainer/PanelContainer/Label.text += str(data) + "\n"
