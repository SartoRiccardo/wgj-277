extends Node2D
class_name Plant

signal grow(plant)
signal harvest(plant)

export (Resource) var data

onready var modifiers = $ModifierManager

var times_grown := 0
var wilted := false
var is_glowing := false
var despawning := false

func _ready() -> void:
	if data == null:
		queue_free()
		return
	
	$TimerGrow.connect("timeout", self, "_on_grow")
	$TimerWilt.connect("timeout", self, "_on_wilted")
	$TimerInteract.connect("timeout", self, "_on_player_interaction")
	$TimerDespawn.connect("timeout", self, "_on_wilt_despawn")
	modifiers.connect("grow_time_change", self, "_on_grow_time_change")
	modifiers.connect("wilt_time_change", self, "_on_wilt_time_change")
	EventBus.connect("game_end", self, "_on_game_end")

func _process(_d):
#	Console.writeln([
#		stepify($TimerGrow.get_progress(), 0.01),
#		stepify($TimerWilt.get_progress(), 0.01), 
#		self,
#		stepify($TimerGrow.time_left, 0.01),
#		stepify($TimerWilt.time_left, 0.01), 
#		stepify($TimerInteract.time_left, 0.01),
#		modifiers.modifiers,
#		times_grown,data.growth_stages-1
#	])
	pass
	
# Public methods

func grow() -> void:
	if times_grown < data.growth_stages-1:
		times_grown += 1
	emit_signal("grow", self)
	$TimerWilt.start(modifiers.wilt_time())
	$TimerGrow.stop()
	
	var sprite_atlas_offset := _get_sprite_offset()
	if sprite_atlas_offset != $Sprite.texture.region.position.x and \
			sprite_atlas_offset < $Sprite.texture.atlas.get_width():
		$AnimationBehavior.play("grow")

func update_sprite() -> void:
	$Sprite.texture.region.position.x = _get_sprite_offset()

func is_waterable() -> bool:
	return false

func is_harvestable() -> bool:
	return !(despawning or wilted)

func is_interactable() -> bool:
	return is_waterable() or is_harvestable()

func set_interact(action: bool) -> void:
	if action and $TimerInteract.is_stopped():
		$TimerInteract.start(data.action_time)
	else:
		$TimerInteract.stop()

func set_glow(glow : bool) -> void:
	if glow == is_glowing:
		return
	is_glowing = glow
	if $AnimationBehavior.is_playing() and $AnimationBehavior.current_animation != "glow":
		yield($AnimationBehavior, "animation_finished")
	if is_glowing:
		$AnimationBehavior.play("glow")
	else:
		$AnimationBehavior.stop()
		$Sprite.material.set_shader_param("intensity", 0.0)

func harvest() -> void:
	emit_signal("harvest", self)
	EventBus.emit_signal("harvest", times_grown < data.growth_stages-1, data.points)
	_despawn()

func die() -> void:
	_despawn(true)

# Private methods

func _get_sprite_offset() -> int:
	var sprite_atlas_idx := floor(float(times_grown)/data.growth_stages * data.growth_stages_sprite)
	return sprite_atlas_idx * $Sprite.texture.region.size.x

func _despawn(killed=false) -> void:
	despawning = true
	$AnimationState.play("death" if killed else "despawn")

# Event handlers

func _on_grow() -> void:
	grow()
	if data.can_wilt:
		$TimerWilt.start(modifiers.wilt_time())

func _on_wilted() -> void:
	wilted = true
	$TimerGrow.set_paused(true)
	$AnimationBehavior.play("wilt")
	$TimerDespawn.start()

func _on_wilt_despawn() -> void:
	$AnimationState.play("death")

func _on_player_interaction() -> void:
	harvest()

func _on_grow_time_change() -> void:
	if $TimerGrow.is_stopped():
		return
	Helpers.update_timer_proportional($TimerGrow, modifiers.grow_time())

func _on_wilt_time_change() -> void:
	if $TimerWilt.is_stopped():
		return
	Helpers.update_timer_proportional($TimerWilt, modifiers.wilt_time())

func _on_game_end() -> void:
	$Shape.set_monitorable(false)
	var timers_to_pause = [$TimerGrow, $TimerWilt, $TimerInteract]
	for timer in timers_to_pause:
		timer.set_paused(true)
	
	var animations_to_finish = [$AnimationBehavior, $AnimationState]
	for animation in animations_to_finish:
		if animation.is_playing():
			yield(animation, "animation_finished")
		animation.stop()
