extends CharacterBody2D
class_name Jump_Vector

@onready var marker: Marker2D = $Marker2D

@export var is_rotating: bool = true

func _process(delta: float) -> void:
	rotate(.01)

func calc_jump_vector() -> Vector2:
	return -(global_position - marker.global_position).normalized()
