extends CharacterBody2D
class_name Player

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var cast: RayCast2D = $RayCast2D
@onready var timer_coyote: Timer = $CoyoteTimer

@export var wall_slide_speed: float = 9000
@export var teleport_range: float = 800
@export var SPEED: float = 25000
@export var JUMP_SPEED: float = -500

var normal_vector: Vector2 = Vector2.UP
var jumped: bool

func _ready() -> void:
	normal_vector = Vector2.UP

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	shoot_ray()
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumped = false
	
	if cast.is_colliding() and Input.is_action_just_pressed("teleport"):
		Engine.time_scale = 0.2
		
	if cast.is_colliding() and Input.is_action_just_released("teleport"):
		Engine.time_scale = 1.0
		get_parent().player_moved = true
		teleport()
		
	if not is_on_wall() and not is_on_floor():
		if direction:
			velocity.x = direction * SPEED/2 * delta
			
	if is_on_floor():
		if direction:
			if direction < 0:
				flip_h(false)
			else:
				flip_h(true)
			animationPlayer.play("walk")
			velocity.x = direction * SPEED * delta
		else:
			animationPlayer.play("idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if not jumped and Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_SPEED
			jumped = true
	
	if is_on_wall_only() and velocity.y > 0:
		wall_slide(delta)
		if Input.is_action_just_pressed("jump"):
			velocity.x = JUMP_SPEED * -get_wall_normal().x
			velocity.y = JUMP_SPEED
			jumped = true
	
	if not jumped and Input.is_action_just_pressed("jump") and (is_on_floor() or not timer_coyote.is_stopped()):
		velocity.y = JUMP_SPEED
		jumped = true
		
	var was_on_floor = is_on_floor()
	move_and_slide()
	if not is_on_floor() and was_on_floor:
		timer_coyote.start()
	queue_redraw()
	
	
func idle():
	if is_on_floor():
		normal_vector = Vector2.UP
		animationPlayer.play("idle")
		
func wall_slide(delta: float):
	var dot_prod = get_wall_normal().dot(Vector2.RIGHT)
	if dot_prod > 0:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
	
	animationPlayer.play("wall_slide")
	velocity.y = wall_slide_speed * delta
		
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

	
