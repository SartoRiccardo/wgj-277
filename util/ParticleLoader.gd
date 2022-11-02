extends Node

export (Array, ParticlesMaterial) var particles
export (Array, ShaderMaterial) var shaders

func _ready():
	var size = max(particles.size(), shaders.size())
	for i in size:
		var particle := Particles2D.new()
		if i < particles.size():
			particle.set_process_material(particles[i])
		if i < shaders.size():
			particle.set_material(shaders[i])
		particle.set_emitting(true)
		add_child(particle)
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()
