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
var was_on_floor: bool
var jump_amount: int

func _ready() -> void:
	normal_vector = Vector2.UP

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var grounded = is_on_floor()
	shoot_ray()
	
	if not grounded:
		velocity += get_gravity() * delta
		animationPlayer.play("wall_slide")
		if direction:
			animatedSprite.flip_h = velocity.x > 0
	else:
		jump_amount = 0
	
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
		velocity.y = JUMP_SPEED - 200 * jump_amount
		jump_amount += 1
	
	if cast.is_colliding() and Input.is_action_just_pressed("teleport"):
		Engine.time_scale = 0.2
		
	if cast.is_colliding() and Input.is_action_just_released("teleport"):
		jump_amount = max(jump_amount - 1, 0)
		Engine.time_scale = 1.0
		get_parent().player_moved = true
		teleport()
	
		
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

	
