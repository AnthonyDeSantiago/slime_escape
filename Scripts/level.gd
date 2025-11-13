extends Node2D

@onready var cast: RayCast2D = $RayCast2D
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var ui_game_over: VBoxContainer = $UI_Layer/UI/Game_Over
@onready var ui_game_win: VBoxContainer = $UI_Layer/UI/Game_Win
@onready var win_coord: Marker2D = $win_coord
@onready var camera: Camera2D = $Path2D/PathFollow2D/Camera2D
@onready var label_game_timer: Label = $UI_Layer/HUD/Game_Timer_Label
@onready var label_game_over: Label = $UI_Layer/UI/Game_Over/Game_Over_Label
@onready var timer_game: Timer = $Game_Timer
@onready var tile_water: TileMapLayer = $water
@onready var player: Player = $player

@export var texture: Texture2D
@export var ray_length: float = 10000
@export var start_rate = 1
@export var speed_up_rate = 5
@export var player_scene: PackedScene
@export var CAM_SPEED = 0.02
@export var start_tilemap_position = 600

var cam_speed
var cast_target_position
var player_moved: bool = false
var viewport_size: Vector2
var viewport_hieght: float
var viewport_width: float
var has_moved: bool = false

func _ready()->void:
	tile_water.global_position.y = start_tilemap_position
	label_game_timer.text = str(int(timer_game.time_left))
	viewport_size = get_viewport().get_visible_rect().size
	viewport_hieght = viewport_size.y
	viewport_width = viewport_size.x

func _draw():
	if cast_target_position and Input.is_action_pressed("teleport"):
		draw_dashed_line(player.global_position, cast_target_position, Color.ALICE_BLUE, 5, 5, true, true)
		draw_circle(cast_target_position, 10, Color.AQUA)

func _process(delta):
	var water_dist_from_top: float = -abs(start_tilemap_position - win_coord.position.y)
	player_has_moved()
	if has_moved:
		move_water(water_dist_from_top, delta)
		pass
	adjust_camera_speed(delta)
	label_game_timer.text = str(int(timer_game.time_left))
	if player_moved:
		path_to_follow.progress_ratio += cam_speed
	if player.global_position.y <= win_coord.global_position.y:
		win_condition()
	
	if player.global_position.y > tile_water.global_position.y:
		lose_condition()


func win_condition():
	get_tree().paused = true
	timer_game.paused = true
	cam_speed = 0
	ui_game_win.visible = true

func lose_condition():
	get_tree().paused = true
	ui_game_over.visible = true
	cam_speed = 0

func adjust_camera_speed(delta):
	var dif = (camera.global_position.y - player.global_position.y) / (viewport_hieght/2)
	
	if player.global_position.y < camera.global_position.y:
		cam_speed = (CAM_SPEED + dif/10) * delta
	else:
		cam_speed = 0
	
func move_water(distance: float, delta: float):
	var water_vel = distance/20
	var new_y = tile_water.global_position.y + water_vel * delta
	tile_water.global_position.y  = new_y
	
func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_try_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.

func _on_game_timer_timeout() -> void:
	label_game_over.text = "Time ran out!"
	lose_condition()

func player_has_moved():
	if Input.is_anything_pressed():
		has_moved = true
