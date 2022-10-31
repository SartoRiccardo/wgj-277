extends Node

export (bool) var active := true
export (float, 0.0, 1.0) var fail_rate := 0.1
export (float) var plant_min_distance := 4.0
export (Array, Resource) var spawn_chances
export (NodePath) var plant_root_path := NodePath("../Plants")

onready var plant_root := get_node_or_null(plant_root_path)

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	$SpawnTimer.connect("timeout", self, "_on_spawn_attempt")
	if active:
		$SpawnTimer.start()

func stop() -> void:
	$SpawnTimer.stop()

func is_too_near_plant(vec2 : Vector2) -> bool:
	for plant in plant_root.get_children():
		if plant.global_position.distance_squared_to(vec2) <= pow(plant_min_distance, 2):
			return true
	return false

func pick_random_plant() -> PackedScene:
	var total_weight := 0.0
	for plant in spawn_chances:
		total_weight += plant.weight
	var result = rng.randf() * total_weight
	for plant in spawn_chances:
		if result <= plant.weight:
			return plant.plant
		result -= plant.weight
	return null

func _on_spawn_attempt() -> void:
	if rng.randf() <= fail_rate:
		return
	
	var children = get_children()
	var spawn_box_corners = []
	for node in children:
		if not node is Position2D:
			continue
		spawn_box_corners.append(node)
	if spawn_box_corners.size() < 2:
		return
	
	var spawn_box := Rect2()
	spawn_box.position = spawn_box_corners[0].global_position
	spawn_box.end = spawn_box_corners[1].global_position
	
	var spawn_attempts := 10
	for __ in spawn_attempts:
		var spawn_position := Vector2(
			rng.randf_range(spawn_box.position.x, spawn_box.end.x),
			rng.randf_range(spawn_box.position.y, spawn_box.end.y)
		)
		if is_too_near_plant(spawn_position):
			continue
		
		var plant_scn := pick_random_plant()
		var plant := plant_scn.instance()
		plant.global_position = spawn_position
		plant_root.add_child(plant)
		break
