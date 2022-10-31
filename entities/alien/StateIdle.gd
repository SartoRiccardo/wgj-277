extends "res://entities/alien/BaseState.gd"

var nearest_plant : Plant = null

# Override
func update(delta : float) -> void:
	if player.controllable:
		player._update_movement_speed(delta)
	else:
		player._slow_movement(delta)
	player._update_sprite()
	
	var new_nearest_plant = player._get_nearest_plant()
	if new_nearest_plant != nearest_plant:
		if nearest_plant:
			nearest_plant.set_glow(false)
		if new_nearest_plant:
			new_nearest_plant.set_glow(new_nearest_plant.is_interactable())
		nearest_plant = new_nearest_plant
	elif is_instance_valid(nearest_plant) and \
			nearest_plant.is_interactable() != nearest_plant.is_glowing:
		nearest_plant.set_glow(nearest_plant.is_interactable())
	
	if Input.is_action_pressed("interact") and player.controllable:
		if nearest_plant and nearest_plant.is_interactable():
			player.call_deferred("_change_state", "interacting")
			player.interact_target = nearest_plant

# Override
func exit() -> void:
	if nearest_plant:
		nearest_plant.set_glow(false)
	nearest_plant = null
