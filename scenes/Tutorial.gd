extends "res://scenes/Game.gd"

onready var btn_play = $GameUI/TutorialUI/Panel/VBox/BtnPlay
onready var scn_game = load("res://scenes/Game.tscn")

func _ready() -> void:
	$GameUI.set_time_visible(false)
	btn_play.connect("pressed", self, "_on_game_start")
	start_tutorial()

func start_tutorial() -> void:
	for i in $Steps.get_child_count():
		var step := $Steps.get_child(i)
		if not step.has_method("enter"):
			continue
		step.enter($GameUI/TutorialUI)
		if i == $Steps.get_child_count()-1:
			break
		
		if not step.has_ended:
			yield(step, "step_end")
		if step.time_before_cleanup > 0:
			$TutorialDelay.start(step.time_before_cleanup)
			yield($TutorialDelay, "timeout")
		step.cleanup()
		if step.time_before_next > 0:
			$TutorialDelay.start(step.time_before_next)
			yield($TutorialDelay, "timeout")
	
	btn_play.set_visible(true)

func _on_game_start() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(scn_game)
