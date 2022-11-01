tool
extends TextureRect
class_name ScalableTexture

export (String, "height", "width") var keep := "height"

func _process(_d : float) -> void:
	if not Engine.editor_hint or texture == null:
		return
	if rect_size.normalized() != texture.get_size().normalized():
		if keep == "height":
			rect_min_size.x = rect_size.y * texture.get_size().x / texture.get_size().y
		else:
			rect_min_size.y = rect_size.x * texture.get_size().y / texture.get_size().x
