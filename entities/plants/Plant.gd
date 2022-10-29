extends Node2D
class_name Plant

signal grow(plant)
signal harvest(plant)

export (Resource) var data

var times_grown := 0
var wilted := false
var is_glowing := false
var modifiers = []

func _ready() -> void:
	if data == null:
		queue_free()
		return
	
	$TimerGrow.connect("timeout", self, "_on_grow")
	$TimerWilt.connect("timeout", self, "_on_wilted")
	$TimerInteract.connect("timeout", self, "_on_player_interaction")
	$TimerWilt.start(data.time_before_wilt)


func _process(_d):
	Console.writeln([
		stepify($TimerGrow.time_left, 0.01),
		stepify($TimerWilt.time_left, 0.01), 
#		$AnimationPlayer.is_playing(),
		stepify($TimerInteract.time_left, 0.01),
	])
	
# Public methods

func grow() -> void:
	if times_grown < data.growth_stages-1:
		times_grown += 1
	
	var sprite_atlas_offset := _get_sprite_offset()
	if sprite_atlas_offset != $Sprite.texture.region.position.x and \
			sprite_atlas_offset < $Sprite.texture.atlas.get_width():
		$AnimationPlayer.play("grow")
		yield($AnimationPlayer, "animation_finished")
	
	$TimerWilt.start(data.time_before_wilt)
	$TimerGrow.stop()
	emit_signal("grow", self)

func update_sprite() -> void:
	$Sprite.texture.region.position.x = _get_sprite_offset()

func is_waterable() -> bool:
	return false

func is_harvestable() -> bool:
	return true

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
	if $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation != "glow":
		yield($AnimationPlayer, "animation_finished")
	if is_glowing:
		$AnimationPlayer.play("glow")
	else:
		$AnimationPlayer.stop()
		$Sprite.material.set_shader_param("intensity", 0.0)

func harvest() -> void:
	emit_signal("harvest", self)
	_despawn()

# Private methods

func _get_sprite_offset() -> int:
	var sprite_atlas_idx := floor(float(times_grown)/data.growth_stages * data.growth_stages_sprite)
	return sprite_atlas_idx * $Sprite.texture.region.size.x

func _despawn() -> void:
	$AnimationPlayer.play("despawn")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

# Event handlers

func _on_grow() -> void:
	grow()
	if data.can_wilt:
		$TimerWilt.start(data.time_before_wilt)

func _on_wilted() -> void:
	wilted = true
	$TimerGrow.set_paused(true)
	$AnimationPlayer.play("wilt")

func _on_player_interaction() -> void:
	_despawn()
