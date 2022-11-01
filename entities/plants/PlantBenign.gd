extends "res://entities/plants/Plant.gd"
class_name PlantBenign

func _ready() -> void:
	if data == null:
		return
	
	$TimerWilt.start(modifiers.wilt_time())
	$InteractIcon.popup()

# Public methods

# Override
func is_waterable() -> bool:
	return !despawning and !wilted and $TimerGrow.is_stopped()

# Override
func is_harvestable() -> bool:
	return .is_harvestable() and times_grown >= data.growth_stages-1

# Event handlers

# Override
func _on_grow() -> void:
	._on_grow()
	$InteractIcon.popup()

# Override
func _on_player_interaction() -> void:
	if is_harvestable():
		harvest()
	else:  # Watered
		EventBus.emit_signal("watered")
		$InteractIcon.retract()
		$TimerWilt.stop()
		$TimerGrow.start(modifiers.grow_time())
