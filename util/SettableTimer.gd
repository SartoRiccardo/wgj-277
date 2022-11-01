extends Timer
class_name SettableTimer

var added := false

func _ready() -> void:
	added = true

func update_time_left(new_time_left : float) -> void:
	if not (added and is_instance_valid(self)):
		return
	var cur_wait_time := wait_time
	start(new_time_left)
	set_wait_time(cur_wait_time)

func get_progress() -> float:
	return 1.0 - time_left/wait_time
