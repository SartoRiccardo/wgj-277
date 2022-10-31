extends Node2D

var points := 0

func _ready() -> void:
	$CanvasLayer/GameUI.set_points(points)
	$GameTime.connect("timeout", self, "_on_game_end")
	EventBus.connect("harvest", self, "_on_plant_harvested")
	
	if not Engine.editor_hint:
		$TileMap.tile_set.tile_set_modulate(1, Color.transparent)

func _process(delta):
	$CanvasLayer/GameUI.set_time_left(ceil($GameTime.time_left))

func _on_game_end() -> void:
	$PlantSpawner.stop()
	EventBus.emit_signal("game_end")

func _on_plant_harvested(uprooted : bool, plant_points : int) -> void:
	if not uprooted:
		points += plant_points
	$CanvasLayer/GameUI.set_points(points)
