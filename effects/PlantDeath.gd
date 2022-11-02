tool
extends Particles2D

func _ready() -> void:
	set_emitting(true)

func set_target(global_point : Vector2) -> void:
	process_material.set_shader_param("target", to_local(global_point))
