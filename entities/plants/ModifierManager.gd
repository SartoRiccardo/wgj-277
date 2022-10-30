extends Node

signal grow_time_change
signal wilt_time_change

export (NodePath) var plant_path := NodePath("..")

var modifiers_affect = {
	"weed": [
		{"method": "grow_time", "signal": "grow_time_change"},
		{"method": "wilt_time", "signal": "wilt_time_change"},
	],
}

var modifiers = []

func add(modifier : Resource) -> void:
	if not modifier in modifiers:
		_change_modifier("_append_modifier", modifier)
	

func remove(modifier : Resource) -> void:
	if modifier in modifiers:
		_change_modifier("_erase_modifier", modifier)

func grow_time() -> float:
	var time : float = get_node(plant_path).data.time_before_grow
	var time_multi := 1.0
	for mod in modifiers:
		if mod.type == "weed" and time_multi > mod.value:
			time_multi = mod.value
	return time / time_multi

func wilt_time() -> float:
	var time : float = get_node(plant_path).data.time_before_wilt
	var time_multi := 1.0
	for mod in modifiers:
		if mod.type == "weed" and time_multi > mod.value:
			time_multi = mod.value
	return time * time_multi

func _append_modifier(modifier: Resource):
	modifiers.append(modifier)

func _erase_modifier(modifier: Resource):
	modifiers.erase(modifier)

func _change_modifier(change_func: String, modifier: Resource) -> void:
	"""
	Calls change_func passing modifier as parameter;
	checks if there's any changes to any behaviors and
	emits signals accordingly if there are.
	"""
	if modifier.type in modifiers_affect:
		var prev_values = []
		for behavior in modifiers_affect[modifier.type]:
			prev_values.append(call(behavior.method))
		
		call(change_func, modifier)
		
		for i in modifiers_affect[modifier.type].size():
			var behavior = modifiers_affect[modifier.type][i]
			if prev_values[i] != call(behavior.method):
				emit_signal(behavior.signal)
	else:
		call(change_func, modifier)
