extends "res://entities/plants/Plant.gd"

onready var behavior_young := preload("res://resources/plants/modifier_weed_young.tres").duplicate()
onready var behavior_grown := preload("res://resources/plants/modifier_weed_grown.tres").duplicate()
onready var current_behavior := behavior_young

func _ready() -> void:
	$TimerGrow.start(data.time_before_grow)
	$SlowGrowth.connect("area_entered", self, "_on_plant_aoe_entered")
	$SlowGrowth.connect("area_exited", self, "_on_plant_aoe_exited")

# Event handlers

# Override
func _on_grow() -> void:
	var old_behavior := current_behavior
	current_behavior = behavior_grown
	for area2d in $SlowGrowth.get_overlapping_areas():
		var plant = area2d.get_parent()
		if !(plant is PlantBenign):
			continue
		plant.modifiers.add(current_behavior)
		plant.modifiers.remove(old_behavior)
	._on_grow()

func _on_plant_aoe_entered(area2d) -> void:
	var plant = area2d.get_parent()
	if !(plant is PlantBenign):
		return
	plant.modifiers.add(current_behavior)

func _on_plant_aoe_exited(area2d) -> void:
	var plant = area2d.get_parent()
	if !(plant is PlantBenign):
		return
	plant.modifiers.remove(current_behavior)
