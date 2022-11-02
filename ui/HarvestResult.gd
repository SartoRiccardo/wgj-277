tool
extends Node2D

func init(uprooted: bool, points : int):
	if uprooted:
		$HBox/PointIcon.hide()
		$HBox/Points.set_text("Uprooted!")
	else:
		$HBox/Points.set_text("+%s" % points)

func _process(_delta : float) -> void:
	$HBox.rect_pivot_offset = $HBox.rect_size / 2.0
