extends KinematicBody2D
class_name Alien

const MAX_SPEED := 300.0
const ACCELLERATION := 300.0

onready var state_nodes = {
	"idle": $States/Idle,
	"interacting": $States/Interacting,
}

var inputs = []
var mov_vector := Vector2.ZERO
var velocity := Vector2.ZERO
var speed := 0.0
var current_state : Node = null
# Interacting state
var interact_target : Plant = null

func _ready() -> void:
	for state in $States.get_children():
		if state.has_method("init"):
			state.init(self)
	_change_state("idle")

func _process(delta : float) -> void:
	_register_inputs()
	current_state.update(delta)
	velocity = move_and_slide(velocity)

# Protected methods

func _change_state(state : String):
	if state_nodes[state] == current_state:
		return
	if current_state != null:
		current_state.exit()
	var state_node : Node = state_nodes[state]
	state_node.enter()
	current_state = state_node

func _register_inputs() -> void:
	var events = ["move_left", "move_right"]
	
	for evt in events:
		if Input.is_action_just_pressed(evt):
			inputs.append(evt)
		elif Input.is_action_just_released(evt):
			inputs.erase(evt)

func _update_movement(delta : float) -> void:
	var new_mov_vector := Vector2.ZERO
	if inputs.size() > 0:
		new_mov_vector = Vector2.LEFT if inputs[inputs.size()-1] == "move_left" else Vector2.RIGHT
	
	if new_mov_vector == Vector2.ZERO:
		_slow_movement(delta)
	else:
		speed = clamp(speed + ACCELLERATION*delta, 0, MAX_SPEED)
	velocity = (speed * new_mov_vector).linear_interpolate(velocity, pow(2, -20*delta))
	mov_vector = new_mov_vector

func _slow_movement(delta : float) -> void:
	speed = lerp(0, velocity.x, pow(2, -15*delta))

func _update_sprite() -> void:
	var anim_name := "idle"
	var flipped = $AnimatedSprite.is_flipped_h()
	
	match mov_vector:
		Vector2.LEFT:
			anim_name = "walk"
			flipped = true
		Vector2.RIGHT:
			anim_name = "walk"
			flipped = false
	
	if $AnimatedSprite.animation != anim_name:
		$AnimatedSprite.set_animation(anim_name)
	$AnimatedSprite.set_flip_h(flipped)

func _get_nearest_plant() -> Plant:
	var nearest_plant : Plant = null
	var nearest_distance := 0.0
	for area2d in $Interact.get_overlapping_areas():
		var distance = area2d.global_position.distance_squared_to(global_position)
		if nearest_plant == null or nearest_distance > distance:
			nearest_plant = area2d.get_parent()
			nearest_distance = distance
	return nearest_plant

# Event handlers
