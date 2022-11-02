extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var plant_position_path := NodePath("../../Plants/WeedPlant")

onready var scn_plant = load("res://entities/plants/PlantWeed.tscn")

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var plant_position := get_node(plant_position_path)
	var plant : Plant = scn_plant.instance()
	plant.position = plant_position.position
	plant.can_wilt = false
	
	plant_position.get_parent().add_child(plant)
	
	yield(plant, "harvest")
	emit_signal("step_end")
