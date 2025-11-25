extends Camera2D
class_name MainCamera


static var instance: MainCamera
@export var duration: float = .25
@export var strength: float = 20
@export var zoom_val: float = .5
@export var target: Node2D

var tw: Tween = null

func _ready():
	zoom = Vector2(zoom_val, zoom_val)
	instance = self
	position_smoothing_enabled = true

func shake(_duration = null, _strength = null):
	var d = _duration if _duration != null else duration
	var s = _strength if _strength != null else strength
	var base_offset = offset
	if tw: tw.kill()
	tw = get_tree().create_tween()
	tw.tween_method(func (delay: float):
		var movement = Vector2(
			randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * s * delay
		offset = base_offset + movement, 1.0, 0.0, d)

func center_on_target():
	pass
	#var vec: Vector2 = (target.global_position - global_position).normalized()
	#var difference = target.global_position.distance_to(global_position)
	
