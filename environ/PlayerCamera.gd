extends Camera2D

export (Color) var background_color := Color.black
export (NodePath) var following_path := NodePath(".")
var following : Node2D = null

func _ready():
	if following == null:
		if following_path != null:
			following = get_node(following_path)
		else:
			following = Helpers.get_player()
	VisualServer.set_default_clear_color(background_color)

func _process(delta):
	if following == null:
		return
	global_position.x = lerp(following.global_position.x, global_position.x, pow(2, -17*delta))
