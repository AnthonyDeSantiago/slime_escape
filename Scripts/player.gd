extends CharacterBody2D
class_name Player

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var cast: RayCast2D = $RayCast2D
@onready var timer_coyote: Timer = $CoyoteTimer
@onready var timer_teleport: Timer = $TeleportCooldown
@onready var bar_teleport_cooldown: TextureProgressBar = $TeleportCooldownBar

@export var wall_slide_speed: float = 9000
@export var teleport_range: float = 800
@export var SPEED: float = 25000
@export var JUMP_SPEED: float = -700
@export var GRAVITY_NORMAL: float = 20
@export var GRAVITY_WALL: float = 10
@export var WALL_JUMP_PUSH_FORCE: float = 200.0

var wall_contact_coyote: float = 0.0
var WALL_CONTACT_COYOTE_TIME: float = 0.2
var wall_jump_lock: float = 0.0
const WALL_JUMP_LOCK_TIME: float = 0.05
var look_dir_x: int = 1

var normal_vector: Vector2 = Vector2.UP
var was_on_floor: bool
var jump_amount: int
var wall_jump_amount: int
var has_moved: bool = false
var cooldown_teleport: float = 1.0

func _ready() -> void:
	normal_vector = Vector2.UP
	timer_teleport.wait_time = cooldown_teleport

func _physics_process(delta: float) -> void:
	bar_teleport_cooldown.global_position = get_global_mouse_position() + Vector2(10, 10)
	bar_teleport_cooldown.value = (cooldown_teleport - timer_teleport.time_left) * 100
	if bar_teleport_cooldown.value >= 100:
		bar_teleport_cooldown.visible = false
	else:
		bar_teleport_cooldown.visible = true
	print("timer: ", timer_teleport.time_left)
	var direction := Input.get_axis("left", "right")
	var grounded = is_on_floor()
	shoot_ray()
	
	if not grounded:
		velocity.y += GRAVITY_NORMAL
		animationPlayer.play("wall_slide")
		if direction:
			animatedSprite.flip_h = velocity.x > 0
	else:
		jump_amount = 0
		wall_jump_amount = 0
	
	if direction:
		velocity.x = direction * SPEED * delta
		if grounded:
			animatedSprite.flip_h = velocity.x > 0
			animationPlayer.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if grounded:
			animationPlayer.play("idle")
		else:
			animationPlayer.play("wall_slide")
			
	if Input.is_action_just_pressed("jump") and (is_on_floor() or not timer_coyote.is_stopped()) and jump_amount < 2:
		velocity.y = JUMP_SPEED - 100 * jump_amount
		jump_amount += 1
		
	if cast.is_colliding() and Input.is_action_just_pressed("teleport") and timer_teleport.is_stopped():
		Engine.time_scale = 0.2
		
	if cast.is_colliding() and Input.is_action_just_released("teleport") and timer_teleport.is_stopped():
		timer_teleport.start()
		jump_amount = max(jump_amount - 1, 0)
		Engine.time_scale = 1.0
		get_parent().player_moved = true
		teleport()
	
	wall_slide(delta)
	was_on_floor = is_on_floor()
	move_and_slide()
	if not is_on_floor() and was_on_floor:
		timer_coyote.start()
	queue_redraw()
	
	
func idle():
	if is_on_floor():
		normal_vector = Vector2.UP
		animationPlayer.play("idle")
		
func wall_slide(delta: float):
	if is_on_floor() or wall_contact_coyote > 0.0 and wall_jump_amount < 1:
		if Input.is_action_just_pressed("jump"):
			wall_jump_amount += 1
			velocity.y = JUMP_SPEED
			if wall_contact_coyote > 0.0:
				velocity.x = -look_dir_x * WALL_JUMP_PUSH_FORCE
				wall_jump_lock = WALL_JUMP_LOCK_TIME
				
	if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
		look_dir_x = sign(velocity.x)
		wall_contact_coyote = WALL_CONTACT_COYOTE_TIME
		velocity.y = GRAVITY_WALL
	else:
		wall_contact_coyote -= delta
		
func shoot_ray():
	cast.target_position = (get_global_mouse_position() - global_position).normalized() * teleport_range
	if cast.is_colliding():
		get_parent().cast_target_position = cast.get_collision_point()
	else:
		get_parent().cast_target_position = Vector2(0, 0)
	get_parent().queue_redraw()

func teleport():
	if cast.is_colliding():
		global_position = cast.get_collision_point()
		velocity = Vector2(0, 0)

func flip_h(flag: bool):
	if flag:
		animatedSprite.flip_h = true
	else:
		animatedSprite.flip_h = false
	
