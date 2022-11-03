extends "res://entities/alien/BaseState.gd"

func _ready() -> void:
	EventBus.connect("game_end", self, "_on_game_end")
	EventBus.connect("game_unpaused", self, "_on_game_unpaused")

# Override
func enter() -> void:
	var is_flipped_h = player.interact_target.global_position.x - player.global_position.x < 0
	
	player.speed = 0.0
	player.velocity = Vector2.ZERO
	var anim_sprite := player.get_node("AnimatedSprite")
	if is_instance_valid(player.interact_target):
		anim_sprite.set_flip_h(is_flipped_h)
		player.interact_target.set_interact(true)
		if player.interact_target is PlantBenign and player.interact_target.is_waterable():
			anim_sprite.set_animation("water")
			var water := player.get_node("Water")
			water.process_material.set_shader_param(
				"direction", Vector3(-1 if is_flipped_h else 1, 0, 0)
			)
			water.position.x = abs(water.position.x) * (-1 if is_flipped_h else 1)
			water.set_emitting(true)
			player.get_node("WaterPlant").play()
		else:
			player.get_node("HarvestPlant").play()
			anim_sprite.set_animation("harvest")
			pass

# Override
func update(_d : float) -> void:
	if Input.is_action_just_released("interact") or !is_instance_valid(player.interact_target) or \
			!player.interact_target.is_interactable():
		player.call_deferred("_change_state", "idle")

# Override
func exit() -> void:
	if is_instance_valid(player.interact_target):
		player.interact_target.set_interact(false)
	player.interact_target = null
	player.get_node("Water").set_emitting(false)
	player.get_node("WaterPlant").stop()
	player.get_node("HarvestPlant").stop()

func _on_game_end() -> void:
	player.call_deferred("_change_state", "idle")

func _on_game_unpaused() -> void:
	if not Input.is_action_pressed("interact"):
		player.call_deferred("_change_state", "idle")
