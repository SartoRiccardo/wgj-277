extends CanvasLayer

onready var scn_pause_menu = load("res://ui/PauseMenu.tscn")

func _ready() -> void:
	$Margin/HBox1/PauseBtn.connect("pressed", self, "_on_pause")

func set_points(points : int) -> void:
	$Margin/HBox1/PointsLbl.text = str(points)

func set_time_left(time_left : int) -> void:
	$Margin/HBox1/TimeLbl.text = str(time_left)

func set_time_visible(time_visible : bool) -> void:
	$Margin/HBox1/TimerIcon.set_visible(time_visible)
	$Margin/HBox1/TimeLbl.set_visible(time_visible)

func open_pause_menu() -> void:
	add_child(scn_pause_menu.instance())

func _on_pause() -> void:
	open_pause_menu()
