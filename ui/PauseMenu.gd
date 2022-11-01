tool
extends Control

onready var scn_menu = load("res://scenes/MainMenu.tscn")
onready var scn_game = load("res://scenes/Game.tscn")

func _ready() -> void:
	$Margin/MenuContainer/VBox/Resume.connect("pressed", self, "_on_resume")
	$Margin/MenuContainer/VBox/Restart.connect("pressed", self, "_on_restart")
#	$Margin/MenuContainer/VBox/Options.connect("pressed", self, "_on_options")
	$Margin/MenuContainer/VBox/Menu.connect("pressed", self, "_on_menu")
	connect("tree_exiting", self, "_on_tree_exiting")
	popup()

func _process(_delta) -> void:
	$Margin/MenuContainer.rect_pivot_offset = $Margin/MenuContainer.rect_size / 2.0
	if Input.is_action_just_pressed("ui_cancel"):
		retract()

func popup() -> void:
	_set_pause(true)
	$AnimationPlayer.play("popup")

func retract() -> void:
	$AnimationPlayer.play_backwards("popup")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _set_pause(pause : bool) -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.set_paused(pause)

func _on_resume() -> void:
	retract()

func _on_restart() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(scn_game)

#func _on_options() -> void:
#	pass

func _on_menu() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(scn_menu)

func _on_tree_exiting() -> void:
	_set_pause(false)
