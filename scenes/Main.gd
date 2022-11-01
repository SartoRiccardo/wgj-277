extends Node
class_name Main

func change_scene_to(node: Node, free_previous=true) -> Node:
	$Transition.cover()
	yield($Transition, "screen_covered")
	
	var prev_scene : Node = null
	if $Root.get_child_count() > 0:
		prev_scene = $Root.get_child(0)
		Helpers.remove_all_children($Root)
	$Root.add_child(node)
	
	$Transition.reveal()
	
	if free_previous and is_instance_valid(prev_scene):
		prev_scene.queue_free()
		return null
	return prev_scene

func change_scene(scene: PackedScene, free_previous=true) -> Node:
	return change_scene_to(scene.instance(), free_previous)

func set_paused(pause : bool) -> void:
	if pause == get_tree().is_paused():
		return
	get_tree().set_pause(pause)
	EventBus.emit_signal("game_paused" if pause else "game_unpaused")
