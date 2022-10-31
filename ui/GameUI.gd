extends MarginContainer

func _ready() -> void:
	$HBox1/PauseBtn.connect("pressed", self, "_on_pause")

func set_points(points : int) -> void:
	$HBox1/PointsLbl.text = str(points)

func set_time_left(time_left : int) -> void:
	$HBox1/TimeLbl.text = str(time_left)

func _on_pause() -> void:
	pass
