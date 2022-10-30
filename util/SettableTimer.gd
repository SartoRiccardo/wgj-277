extends Timer
class_name SettableTimer

func update_time_left(new_time_left : float) -> void:
	var cur_wait_time := wait_time
	start(new_time_left)
	set_wait_time(cur_wait_time)

func get_progress() -> float:
	return 1.0 - time_left/wait_time
