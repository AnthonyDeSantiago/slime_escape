extends Node2D

@onready var player = $player
@onready var line_drawer = $line_drawer
@onready var cast: RayCast2D = $RayCast2D
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D
@export var texture: Texture2D
@export var ray_length: float = 10000
@export var start_rate = 1
@export var speed_up_rate = 5

const CAM_SPEED = 0
var new_position
var current_norm
var norm
var rate = 1
var epsilon = 0.25
var is_clockwise = true
var is_on_wall = false

func _draw():
	if new_position:
		draw_dashed_line(player.global_position, new_position, Color.WHEAT, 10, 20, true, true)
		draw_circle(new_position, 25, Color.GREEN)
		#if norm:
			#draw_line(cast.get_collision_point(), norm + new_position,  Color.RED, 10)

func _ready():
	cast.global_position = player.global_position
	rate = start_rate
	cast.exclude_parent = true
	cast.target_position = cast.target_position * ray_length
	norm = cast.target_position

func _process(delta):
	cast.target_position = cast.target_position.rotated(rate * delta)
	if current_norm:
		var approaching_max = abs(cast.target_position.angle_to(current_norm.rotated(PI/2 - epsilon)))
		var approaching_min = abs(cast.target_position.angle_to(current_norm.rotated(-PI/2 + epsilon)))
		#print("max:", approaching_max, " min:", approaching_min)
		
		if approaching_max < epsilon:
			rotate_counter_clockwise()
			
		if approaching_min < epsilon:
			rotate_clockwise()
		
	path_to_follow.progress_ratio += CAM_SPEED * delta
	
	if cast.is_colliding():
		new_position = cast.get_collision_point()
		norm = (cast.get_collision_normal() * ray_length)
	else:
		new_position = null
		norm = null
	
	if cast.is_colliding() and Input.is_action_just_pressed("jump") and new_position:
		player.global_position = new_position + cast.get_collision_normal()
		cast.global_position = player.global_position
		cast.target_position = norm
		current_norm = norm
	
	queue_redraw()

func rotate_clockwise():
	rate = abs(rate)

func rotate_counter_clockwise():
	rate = -rate
