extends CharacterBody2D
class_name Jump_Vector

@onready var marker: Marker2D = $Marker2D

func calc_jump_vector() -> Vector2:
	return -(global_position - marker.global_position).normalized()
