extends "res://entities/alien/BaseState.gd"

var nearest_plant : Plant = null

# Override
func enter() -> void:
	pass

# Override
func update(delta : float) -> void:
	player._update_movement(delta)
	player._update_sprite()
	
	var new_nearest_plant = player._get_nearest_plant()
	if new_nearest_plant != nearest_plant:
		if nearest_plant:
			nearest_plant.set_glow(false)
		if new_nearest_plant:
			new_nearest_plant.set_glow(true)
		nearest_plant = new_nearest_plant
	
	if Input.is_action_pressed("interact"):
		if nearest_plant and (nearest_plant.is_waterable() or nearest_plant.is_harvestable()):
			player.call_deferred("_change_state", "interacting")
			player.interact_target = nearest_plant

# Override
func exit() -> void:
	if nearest_plant:
		nearest_plant.set_glow(false)
	nearest_plant = null
