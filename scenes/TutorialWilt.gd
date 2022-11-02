extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var plant_position_path := NodePath("../../Plants/WiltPlant")

onready var scn_plant = load("res://entities/plants/PlantRegular.tscn")

var plant : PlantBenign

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var plant_position := get_node(plant_position_path)
	plant = scn_plant.instance()
	plant.position = plant_position.position
	
	plant_position.get_parent().add_child(plant)
	
	yield(plant, "wilted")
	emit_signal("step_end")

func cleanup() -> void:
	get_node(plant_position_path).queue_free()
	if plant:
		plant.die()
