extends Node

func get_first_of_group(group : String) -> Node:
	var nodes = get_tree().get_nodes_in_group(group)
	if nodes.size() == 0:
		return null
	return nodes[0]

func get_player() -> Node:
	return get_first_of_group("playable")

func update_timer_proportional(timer : SettableTimer, wait_time : float) -> void:
	var progress : float = timer.get_progress()
	timer.set_wait_time(wait_time)
	timer.update_time_left(wait_time*(1.0-progress))
