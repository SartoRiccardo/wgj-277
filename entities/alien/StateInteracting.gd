extends "res://entities/alien/BaseState.gd"

# Override
func enter() -> void:
	player.speed = 0.0
	player.velocity = Vector2.ZERO
	player.get_node("AnimatedSprite").set_animation("water")
	if is_instance_valid(player.interact_target):
		player.get_node("AnimatedSprite").set_flip_h(
			player.interact_target.global_position.x - player.global_position.x < 0
		)
		player.interact_target.set_interact(true)
		player.interact_target.connect("grow", self, "_on_interaction_finish")
		player.interact_target.connect("harvest", self, "_on_interaction_finish")

# Override
func update(delta : float) -> void:
	if Input.is_action_just_released("interact") or !is_instance_valid(player.interact_target) or \
			!player.interact_target.is_interactable():
		player.call_deferred("_change_state", "idle")

# Override
func exit() -> void:
	if is_instance_valid(player.interact_target):
		player.interact_target.set_interact(false)
		player.interact_target.disconnect("grow", self, "_on_interaction_finish")
		player.interact_target.disconnect("harvest", self, "_on_interaction_finish")
	player.interact_target = null

func _on_interaction_finish(_plant) -> void:
	player.call_deferred("_change_state", "idle")
