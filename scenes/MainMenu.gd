extends CanvasLayer

onready var SCN_GAME := load("res://scenes/Game.tscn")
onready var SCN_TUTORIAL := load("res://scenes/Tutorial.tscn")
#onready var SCN_OPTIONS := load("res://scenes/Options.tscn")
onready var SCN_CREDITS := load("res://scenes/Credits.tscn")

func _ready() -> void:
	$Root/VBox1/BtnPlay.connect("pressed", self, "_on_play")
	$Root/VBox1/BtnTutorial.connect("pressed", self, "_on_tutorial")
	$Root/VBox1/BtnCredits.connect("pressed", self, "_on_credits")
	$Root/VBox1/BtnQuit.connect("pressed", self, "_on_quit")

func _on_play() -> void:
	Helpers.main_node().change_scene(SCN_GAME)

func _on_tutorial() -> void:
	Helpers.main_node().change_scene(SCN_TUTORIAL)

#func _on_options() -> void:
#	Helpers.main_node().change_scene(SCN_OPTIONS)

func _on_credits() -> void:
	Helpers.main_node().change_scene(SCN_CREDITS)

func _on_quit() -> void:
	get_tree().quit()
