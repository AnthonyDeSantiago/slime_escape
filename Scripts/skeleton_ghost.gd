extends CharacterBody2D
class_name Skeleton_Ghost


const SPEED = 300.0

@export var player: Player

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if player and global_position.distance_to(player.global_position) > 50:
		velocity = -(global_position - player.global_position).normalized() * SPEED
		anim.play("fly")
	move_and_slide()
