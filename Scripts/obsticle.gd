extends CharacterBody2D
class_name Obsticle

@export var is_rotating = false
@export var rotate_speed = .25
func _physics_process(delta: float) -> void:
	if is_rotating:
		rotate(180/3.14 * rotate_speed * delta)
