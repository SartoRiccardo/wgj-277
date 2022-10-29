extends "res://entities/plants/Plant.gd"
class_name PlantBenign


func _ready() -> void:
	$TimerWater.connect("timeout", self, "_on_watered")

# Public methods

# Override
func is_waterable() -> bool:
	return !wilted and $TimerGrow.is_stopped()

# Override
func is_harvestable() -> bool:
	return wilted or times_grown >= data.growth_stages-1

# Event handlers

# Override
func _on_player_interaction() -> void:
	if is_harvestable():
		harvest()
	else:
		$TimerWilt.stop()
		$TimerGrow.start(data.time_before_grow)
