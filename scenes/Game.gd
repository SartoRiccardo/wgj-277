extends Node2D

onready var game_over_ui := load("res://ui/GameOver.tscn")

var points := 0
var harvested := 0
var uprooted := 0
var watered := 0

func _ready() -> void:
	$GameUI.set_points(points)
	$GameTime.connect("timeout", self, "_on_game_end")
	EventBus.connect("harvest", self, "_on_plant_harvested")
	EventBus.connect("watered", self, "_on_plant_watered")
	
	if not Engine.editor_hint:
		$TileMap.tile_set.tile_set_modulate(1, Color.transparent)

func _process(delta):
	$GameUI.set_time_left(ceil($GameTime.time_left))
	if Input.is_action_just_pressed("ui_cancel"):
		$GameUI.open_pause_menu()

func _on_game_end() -> void:
	$PlantSpawner.stop()
	EventBus.emit_signal("game_end")
	yield(get_tree().create_timer(1.0), "timeout")
	var game_over : Node = game_over_ui.instance()
	game_over.points = points
	game_over.harvested = harvested
	game_over.uprooted = uprooted
	game_over.watered = watered
	$GameUI.add_child(game_over)

func _on_plant_harvested(is_uprooted : bool, plant_points : int) -> void:
	if not is_uprooted:
		harvested += 1
		points += plant_points
	else:
		uprooted += 1
	$GameUI.set_points(points)

func _on_plant_watered() -> void:
	watered += 1
