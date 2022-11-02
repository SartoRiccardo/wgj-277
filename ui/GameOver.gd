extends Control

onready var scn_main_menu := load("res://scenes/MainMenu.tscn")
onready var scn_game := load("res://scenes/Game.tscn")

onready var lbl_points := $Margin/Panel/Margin/VBox/HBox1/Points
onready var lbl_harvested := $Margin/Panel/Margin/VBox/HBox2/Harvested
onready var lbl_uprooted := $Margin/Panel/Margin/VBox/HBox4/Uprooted
onready var lbl_watered := $Margin/Panel/Margin/VBox/HBox5/Watered

var ui_points := 0
var ui_harvested := 0
var ui_uprooted := 0
var ui_watered := 0

var points = 1000
var harvested = 100
var uprooted = 50
var watered = 500

func _ready() -> void:
	$Margin/Panel/Margin/VBox/HBox3/BtnMenu.connect("pressed", self, "_on_menu_pressed")
	$Margin/Panel/Margin/VBox/HBox3/BtnPlay.connect("pressed", self, "_on_play_pressed")

func _process(_d : float) -> void:
	lbl_points.set_text(str(ui_points))
	lbl_harvested.set_text(str(ui_harvested))
	lbl_uprooted.set_text(str(ui_uprooted))
	lbl_watered.set_text(str(ui_watered))

func animate_stats() -> void:
	var tween := create_tween()
	tween.tween_property(self, "ui_points", points, points*0.001)
	if points > 0:
		tween.parallel().tween_callback($Points, "play")
		tween.tween_callback($Points, "stop")
	
	tween.tween_property(self, "ui_harvested", harvested, harvested*0.01) \
		.set_delay(0.5)
	if harvested > 0:
		tween.parallel().tween_callback($Points, "play").set_delay(0.5)
		tween.tween_callback($Points, "stop")
	
	tween.tween_property(self, "ui_uprooted", uprooted, uprooted*0.01) \
		.set_delay(0.5)
	if uprooted > 0:
		tween.parallel().tween_callback($Points, "play").set_delay(0.5)
		tween.tween_callback($Points, "stop")
	
	tween.tween_property(self, "ui_watered", watered, watered*0.005) \
		.set_delay(0.5)
	if watered > 0:
		tween.parallel().tween_callback($Points, "play").set_delay(0.5)
		tween.tween_callback($Points, "stop")

func _on_menu_pressed() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(scn_main_menu)

func _on_play_pressed() -> void:
	var main_node = Helpers.main_node()
	if main_node:
		main_node.change_scene(scn_game)
