extends "res://entities/alien/BaseState.gd"

func _ready() -> void:
	EventBus.connect("game_end", self, "_on_game_end")

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

func _on_game_end() -> void:
	player.call_deferred("_change_state", "idle")
