extends "res://entities/plants/Plant.gd"

onready var SCN_ABSORB_PARTICLE = preload("res://effects/PlantDeath.tscn")

var growing := false

func _ready() -> void:
	if data == null:
		return
	
	$TimerGrow.start(modifiers.grow_time())

func _process(_d: float) -> void:
	if despawning:
		return
	
	if growing and !wilted:
		_attempt_grow()

# Override
func grow() -> void:
	.grow()
	$TimerGrow.start(modifiers.grow_time())
	$TimerWilt.stop()

func _attempt_grow() -> void:
	var areas = $EatRange.get_overlapping_areas()
	var nearest : Plant = null
	var nearest_distance := 0.0
	for a2d in areas:
		var plant : Plant = a2d.get_parent()
		if plant == self:
			continue
		
		var plant_distance := plant.global_position.distance_squared_to(global_position)
		if nearest == null and !plant.wilted or \
				plant_distance < nearest_distance:
			nearest = plant
			nearest_distance = plant_distance
	
	if nearest != null:
		growing = false
		var absorb_particles = SCN_ABSORB_PARTICLE.instance()
		absorb_particles.global_position = nearest.global_position
		Helpers.get_first_of_group("particle_root").add_child(absorb_particles)
		absorb_particles.set_target(global_position)
		
		nearest.die()
		$GrowDelay.start()
		yield($GrowDelay, "timeout")
		grow()

# Event handlers

# Override
func _on_grow() -> void:
	growing = true
	if data.can_wilt:
		$TimerWilt.start(modifiers.wilt_time())
