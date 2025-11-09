extends CharacterBody2D
class_name Player

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

@export var wall_slide_speed: float = 100

var friction = 1000
var viewport_hieght
var viewport_width
var viewport_position

var normal_vector: Vector2 = Vector2.UP

func _ready() -> void:
	viewport_hieght = get_viewport_rect().size.y
	viewport_width = get_viewport_rect().size.x
	viewport_position = get_viewport_rect().position
	#print("hieght:", viewport_hieght, " width:", viewport_width, " position:", viewport_position)
	normal_vector = Vector2.UP

func _draw() -> void:
	if normal_vector:
		draw_line(Vector2(0, 0), (normal_vector) * 100, Color.RED, 10, false)

func _physics_process(delta: float) -> void:
	viewport_position = get_viewport_rect().position
	if not is_on_floor() and not is_on_wall():
		velocity += get_gravity() * delta
	
	if not is_on_floor() and not is_on_wall():
		normal_vector = Vector2(0, 0)
		pass
		
	wall_slide(delta)
	idle()
	move_and_slide()
	queue_redraw()
	
func idle():
	if is_on_floor():
		normal_vector = Vector2.UP
		animationPlayer.play("idle")
		pass
func wall_slide(delta: float):
	if is_on_wall_only():
		var dot_prod = get_wall_normal().dot(Vector2.RIGHT)
		if dot_prod > 0:
			animatedSprite.flip_h = false
			normal_vector = Vector2.RIGHT
		else:
			animatedSprite.flip_h = true
			normal_vector = Vector2.LEFT
		animationPlayer.play("wall_slide")
		velocity.y = friction * delta
