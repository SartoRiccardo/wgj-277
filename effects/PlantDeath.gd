tool
extends Particles2D

export (Curve) var speed_multiplier;

var elapsed := 0.0

func _ready() -> void:
	set_emitting(true)
	preprocess = elapsed

func _process(delta: float) -> void:
	elapsed += delta
	while elapsed > lifetime:
		elapsed -= lifetime
		if one_shot and not Engine.editor_hint:
			queue_free()
	process_material.set_shader_param("elapsed", elapsed)
	process_material.set_shader_param("velocity_multi", speed_multiplier.interpolate(elapsed/lifetime))

func set_target(global_point : Vector2) -> void:
	process_material.set_shader_param("target", to_local(global_point))
