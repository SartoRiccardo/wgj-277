extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var plant_root := NodePath("../../Plants")

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var plant : PlantBenign
	for child in get_node(plant_root).get_children():
		if child is PlantBenign:
			plant = child
			break
	if plant:
		yield(plant, "grow")
	emit_signal("step_end")
