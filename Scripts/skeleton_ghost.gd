extends CharacterBody2D
class_name Skeleton_Ghost


const SPEED = 300.0

@export var player: Player

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider_attack: CollisionShape2D = $area_attack/collider_attack

var died: bool = false
var within_range: bool = false
var within_attack_range: bool = false
var is_awake: bool = false

func _physics_process(delta: float) -> void:
	flip_sprite()
	if player and not is_awake and within_range:
		velocity = Vector2(0, 0)
		anim.play("wake")
		
	if player and within_range and not within_attack_range and not died and is_awake:
		velocity = -(global_position - player.global_position).normalized() * SPEED
		anim.play("fly")
	
	if within_attack_range:
		velocity = Vector2(0, 0)
		anim.play("attack")
	
	if anim.animation == "attack":
		if anim.frame == 5:
			collider_attack.disabled = false
		else:
			collider_attack.disabled = true
	
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

func _on_player_within_attack_range(area: Area2D) -> void:
	if area.get_parent() is Player:
		within_attack_range = true

func _on_player_exit_attack_range(area: Area2D) -> void:
	if area.get_parent() is Player:
		within_attack_range = false

func flip_sprite():
	if player:
		if player.global_position.x > global_position.x:
			anim.flip_h = true
		else:
			anim.flip_h = false

func _on_attack_landed(area: Area2D) -> void:
	if area.get_parent() is Player:
		print("attack landed")
