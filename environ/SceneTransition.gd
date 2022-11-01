extends CanvasLayer

signal screen_covered
signal screen_revealed

func cover():
	_play_anim("cover", "screen_covered")

func reveal():
	_play_anim("reveal", "screen_revealed")

func _play_anim(name : String, signal_at_end : String):
	if $AnimationPlayer.is_playing():
		yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play(name)
	yield($AnimationPlayer, "animation_finished")
	emit_signal(signal_at_end)
