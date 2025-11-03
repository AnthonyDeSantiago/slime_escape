extends Node2D

@onready var player = $player
@onready var line_drawer = $line_drawer
@onready var cast: RayCast2D = $player/RayCast2D

var circle_pos: Vector2
var new_position: Vector2

func _draw():
	if circle_pos:
		draw_circle(circle_pos, 25, Color.GREEN)

func _ready():
	line_drawer.start = player.global_position
	line_drawer.end = get_global_mouse_position()
	line_drawer.queue_redraw()
	cast.exclude_parent = true

func _physics_process(delta):
	cast.target_position = (get_global_mouse_position() - player.global_position).normalized() * 1000
	line_drawer.start = player.global_position
	line_drawer.end = get_global_mouse_position()
	line_drawer.queue_redraw()
	
	var space_state = get_world_2d().direct_space_state
	var jump_vec = get_global_mouse_position().normalized() * 1000
	var query = PhysicsRayQueryParameters2D.create(player.global_position, jump_vec)
	var result = space_state.intersect_ray(query)
	
	
	if Input.is_action_just_pressed("jump") and new_position:
		player.global_position = new_position
	
	if result:
		print(result)
		circle_pos = cast.get_collision_point()
		new_position = cast.get_collision_point()
		queue_redraw()
