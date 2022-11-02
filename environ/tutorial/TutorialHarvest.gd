extends "res://environ/tutorial/TutorialStep.gd"

export (NodePath) var plant_root := NodePath("../../Plants")

func enter(label : TutorialUI) -> void:
	.enter(label)
	
	var plant : PlantBenign
	for child in get_node(plant_root).get_children():
		if child is PlantBenign:
			plant = child
			break
	if plant and not plant.despawning:
		yield(plant, "harvest")
	else:
		time_before_next = 0.0
		has_ended = true
	emit_signal("step_end")
