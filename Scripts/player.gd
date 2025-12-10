extends CharacterBody2D
class_name Player

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var cast: RayCast2D = $RayCast2D
@onready var timer_coyote: Timer = $CoyoteTimer
@onready var timer_teleport: Timer = $TeleportCooldown
@onready var bar_teleport_cooldown: TextureProgressBar = $TeleportCooldownBar
@onready var projectile_spawn: Marker2D = $projectile_spawn

@export_group("Player Settings")
@export var SPEED: float = 25000
@export var JUMP_SPEED: float = -700
@export var GRAVITY_NORMAL: float = 20
@export var GRAVITY_WALL: float = 10
@export var WALL_JUMP_PUSH_FORCE: float = 200.0

@export_category("Wall Slide Settings")
@export var WALL_CONTACT_COYOTE_TIME: float = 0.2
@export var WALL_JUMP_LOCK_TIME: float = 0.05


@export_group("Wand Settings")
@export var teleport_range: float = 800
@export var projectile_scene: PackedScene
@export var cooldown_teleport: float = 1.0


# WALL SLIDE
var wall_contact_coyote: float = 0.0
var wall_jump_lock: float = 0.0
var wall_jump_count: int = 0
var look_dir_x: int = 1

# PLAYER MOVEMENT
var isGrounded: bool = false
var has_moved: bool = false
var was_on_floor: bool
var jump_amount: int

# PUBLIC VARS
var knockback_timer: float = 0.0
var knockback: Vector2 = Vector2.ZERO


func _ready() -> void:
	timer_teleport.wait_time = cooldown_teleport

func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY_NORMAL
		isGrounded = false
	else:
		isGrounded = true
	#if knockback_timer > 0.0:
		#velocity = knockback
		#knockback_timer -= delta
		#if knockback_timer < 0.0:
			#knockback = Vector2.ZERO
	#else:
		#_movement(delta)
	#
	move_and_slide()
	#if not is_on_floor() and was_on_floor:
		#timer_coyote.start()
	
	_wand(_delta)
	queue_redraw()

func _wand(_delta: float):
	if Input.is_action_just_pressed("shoot"):
		Engine.time_scale = .2
	if Input.is_action_just_released("shoot"):
		Engine.time_scale = 1
		var projectile: Projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = projectile_spawn.global_position
		projectile.move_vec = (get_global_mouse_position() - projectile_spawn.global_position).normalized() * 300
		projectile.look_at(get_global_mouse_position())
	
	bar_teleport_cooldown.global_position = get_global_mouse_position() + Vector2(10, 10)
	bar_teleport_cooldown.value = (cooldown_teleport - timer_teleport.time_left) * 100
	if bar_teleport_cooldown.value >= 100:
		bar_teleport_cooldown.visible = false
	else:
		bar_teleport_cooldown.visible = true
	shoot_ray()
	if cast.is_colliding() and Input.is_action_just_pressed("teleport") and timer_teleport.is_stopped():
		Engine.time_scale = 0.2
		
	if cast.is_colliding() and Input.is_action_just_released("teleport") and timer_teleport.is_stopped():
		timer_teleport.start()
		jump_amount = max(jump_amount - 1, 0)
		Engine.time_scale = 1.0
		get_parent().player_moved = true
		teleport()
		
func _movement(delta: float):
	var direction := Input.get_axis("left", "right")
	var grounded = is_on_floor()
	
	if not grounded:
		velocity.y += GRAVITY_NORMAL
		animationPlayer.play("wall_slide")
		if direction:
			flip_h(velocity.x > 0)
	else:
		jump_amount = 0
	
	if direction:
		flip_h(velocity.x > 0)
		velocity.x = direction * SPEED * delta
		if grounded:
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
	
	wall_slide(delta)
	was_on_floor = is_on_floor()
	pass
	
func idle():
	if is_on_floor():
		animationPlayer.play("idle")
		
func wall_slide(delta: float):
	if is_on_floor() or wall_contact_coyote > 0.0:
		if Input.is_action_just_pressed("jump"):
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
		projectile_spawn.position.x = abs(projectile_spawn.position.x)
		if not is_on_floor():
			projectile_spawn.position.x = -abs(projectile_spawn.position.x)
	else:
		animatedSprite.flip_h = false
		projectile_spawn.position.x = -abs(projectile_spawn.position.x)
		if not is_on_floor():
			projectile_spawn.position.x = abs(projectile_spawn.position.x)
	
func reset_teleport_cooldown():
	timer_teleport.stop()

func take_damage():
	MainCamera.instance.shake()
	$anim_effects.play("take_hit")

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
