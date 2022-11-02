extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var path_pos_plant_eater := NodePath("../../Plants/EaterPlant")
export (NodePath) var path_pos_plant_prey := NodePath("../../Plants/EaterPlantPrey")

onready var scn_plant_eater = load("res://entities/plants/PlantEater.tscn")
onready var scn_plant_prey = load("res://entities/plants/PlantRegular.tscn")

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var pos_plant_eater := get_node(path_pos_plant_eater)
	var plant_eater : Plant = scn_plant_eater.instance()
	plant_eater.position = pos_plant_eater.position
	plant_eater.can_wilt = false
	pos_plant_eater.get_parent().add_child(plant_eater)
	
	var pos_plant_prey := get_node(path_pos_plant_prey)
	var plant_prey : Plant = scn_plant_prey.instance()
	plant_prey.position = pos_plant_prey.position
	plant_prey.can_wilt = false
	pos_plant_prey.get_parent().add_child(plant_prey)
	
	yield(plant_eater, "grow")
	emit_signal("step_end")

func cleanup() -> void:
	pass
