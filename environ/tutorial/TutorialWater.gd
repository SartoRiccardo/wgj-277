extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var plant_position_path := NodePath("../../Plants/WaterPlant1")

onready var scn_plant = load("res://entities/plants/PlantRegular.tscn")

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var plant_position := get_node(plant_position_path)
	var plant : PlantBenign = scn_plant.instance()
	plant.times_grown = plant.data.growth_stages-2
	plant.position = plant_position.position
	plant.can_wilt = false
	plant.update_sprite()
	
	plant_position.get_parent().add_child(plant)
	
	yield(plant, "watered")
	emit_signal("step_end")

func cleanup() -> void:
	get_node(plant_position_path).queue_free()
