extends CharacterBody2D
class_name Player

@onready var jump_vector_node: Jump_Vector = $jump_vector
@onready var this_area: CollisionShape2D = $Area2D/CollisionShape2D
const SPEED = 1000
const JUMP_VELOCITY = -400.0
const rotation_rate = .08

var jump_vec
var reverse = false
var circle_pos: Vector2
var new_position: Vector2

func _physics_process(delta: float) -> void:
	jump_vec = -(global_position - get_global_mouse_position()).normalized()
	
	if reverse:
		jump_vector_node.rotate(180/3.14 * rotation_rate * delta)
	else:
		jump_vector_node.rotate(-180/3.14 * rotation_rate * delta)
		#reverse = !reverse
	
	move_and_slide()



func _on_timer_timeout() -> void:
	this_area.disabled = false
	pass # Replace with function body.
