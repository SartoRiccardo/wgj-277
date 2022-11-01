extends Node2D

export (AtlasTexture) var icon_water : AtlasTexture = null
export (AtlasTexture) var icon_harvest : AtlasTexture = null
export (bool) var active := false
onready var icons = {
	"water": icon_water,
	"harvest": icon_harvest,
}

func _ready() -> void:
	set_icon("water")

func _process(delta):
	Console.writeln([
		scale,
		position
	])

func set_icon(icon_type : String) -> void:
	$Texture.texture = icons[icon_type]
	$Texture.offset = $Texture.texture.get_size()/2.0
	$Texture.position = -$Texture.offset

func popup() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", -57.0, 0.5)
	tween.parallel().tween_property(self, "scale", Vector2.ONE*2, 0.5)

func retract() -> void:
	var tween := create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 0.0, 0.5)
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, .5)
