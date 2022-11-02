tool
extends Node2D

var uprooted := false

func _ready() -> void:
	if uprooted:
		$HarvestUproot.play()
	else:
		$HarvestMature.play()

func init(p_uprooted: bool, points : int) -> void:
	uprooted = p_uprooted
	if uprooted:
		$HBox/PointIcon.hide()
		$HBox/Points.set_text("Uprooted!")
	else:
		$HBox/Points.set_text("+%s" % points)

func _process(_delta : float) -> void:
	$HBox.rect_pivot_offset = $HBox.rect_size / 2.0
