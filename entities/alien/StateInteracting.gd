extends "res://entities/alien/BaseState.gd"

# Override
func enter() -> void:
	player.speed = 0.0
	player.velocity = Vector2.ZERO
	player.get_node("AnimatedSprite").set_animation("water")
	if player.interact_target:
		player.get_node("AnimatedSprite").set_flip_h(
			player.interact_target.global_position.x - player.global_position.x < 0
		)

# Override
func update(delta : float) -> void:
	if Input.is_action_just_released("interact") or !is_instance_valid(player.interact_target):
		player.call_deferred("_change_state", "idle")

# Override
func exit() -> void:
	player.interact_target = null
