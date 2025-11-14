extends CharacterBody2D
class_name Skeleton_Ghost


const SPEED = 300.0

@export var player: Player

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var died: bool = false
var within_range: bool = false
var is_awake: bool = false

func _physics_process(delta: float) -> void:
	print(anim.animation)
	if player and not is_awake and within_range:
		velocity = Vector2(0, 0)
		anim.play("wake")
		
	if player and within_range and global_position.distance_to(player.global_position) > 50 and not died and is_awake:
		velocity = -(global_position - player.global_position).normalized() * SPEED
		anim.play("fly")
	move_and_slide()

func die():
	velocity = Vector2(0, 0)
	died = true
	anim.play("death")


func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "death":
		queue_free()
	if anim.animation == "wake":
		is_awake = true
		

func _on_player_within_range(area: Area2D) -> void:
	if area.get_parent() is Player:
		within_range = true
