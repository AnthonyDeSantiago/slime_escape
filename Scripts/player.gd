extends CharacterBody2D
class_name Player

@onready var jump_vector_node: Jump_Vector = $jump_vector
@onready var jump_timer: Timer = $Timer
@onready var this_area: CollisionShape2D = $Area2D/CollisionShape2D

const SPEED = 1000
const JUMP_VELOCITY = -400.0
const rotation_rate = .08

var is_stuck = false
var jump_vec
var reverse = false

func _physics_process(delta: float) -> void:
	if reverse:
		jump_vector_node.rotate(180/3.14 * rotation_rate * delta)
	else:
		jump_vector_node.rotate(-180/3.14 * rotation_rate * delta)
	if Input.is_action_just_pressed("jump"):
		#reverse = !reverse
		is_stuck = false
		jump_vec = jump_vector_node.calc_jump_vector()
		velocity = jump_vec * SPEED
		reparent(get_parent().get_parent())
		jump_timer.start()
		this_area.disabled = true
	
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	velocity = Vector2(0, 0)
	print("collided")
	reparent(area.get_parent())
	is_stuck = true
	pass # Replace with function body.


func _on_timer_timeout() -> void:
	this_area.disabled = false
	jump_timer.stop()
	pass # Replace with function body.
