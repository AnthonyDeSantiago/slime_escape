extends Node2D

@onready var line_drawer = $line_drawer
@onready var cast: RayCast2D = $RayCast2D
@onready var path_to_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var ui_game_over: VBoxContainer = $UI_Layer/UI/Game_Over
@onready var ui_game_win: VBoxContainer = $UI_Layer/UI/Game_Win
@onready var win_coord: Marker2D = $win_coord
@onready var camera: Camera2D = $Path2D/PathFollow2D/Camera2D
@onready var label_game_timer: Label = $UI_Layer/HUD/Game_Timer_Label
@onready var label_game_over: Label = $UI_Layer/UI/Game_Over/Game_Over_Label
@onready var timer_game: Timer = $Game_Timer

@export var texture: Texture2D
@export var ray_length: float = 10000
@export var start_rate = 1
@export var speed_up_rate = 5
@export var player_scene: PackedScene

var CAM_SPEED = .02
var player: Player
var cast_target_position
var player_moved: bool = false
var viewport_size: Vector2
var viewport_hieght: float
var viewport_width: float

func _ready()->void:
	label_game_timer.text = str(int(timer_game.time_left))
	viewport_size = get_viewport().get_visible_rect().size
	viewport_hieght = viewport_size.y
	viewport_width = viewport_size.x
	player = player_scene.instantiate()
	add_child(player)

func _draw():
	if cast_target_position and Input.is_action_pressed("teleport"):
		draw_dashed_line(player.global_position, cast_target_position, Color.ALICE_BLUE, 5, 5, true, true)
		draw_circle(cast_target_position, 10, Color.AQUA)

func _process(delta):
	label_game_timer.text = str(int(timer_game.time_left))
	if player_moved:
		path_to_follow.progress_ratio += CAM_SPEED * delta
	
	if player.global_position.y <= win_coord.global_position.y:
		win_condition()
	
	if (camera.global_position.y + viewport_hieght/2) < player.global_position.y:
		lose_condition()


func win_condition():
	get_tree().paused = true
	timer_game.paused = true
	CAM_SPEED = 0
	ui_game_win.visible = true

func lose_condition():
	get_tree().paused = true
	ui_game_over.visible = true
	CAM_SPEED = 0

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
