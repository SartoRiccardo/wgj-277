extends Node

func get_first_of_group(group : String) -> Node:
	var nodes = get_tree().get_nodes_in_group(group)
	if nodes.size() == 0:
		return null
	return nodes[0]

func get_player():
	return get_first_of_group("playable")
