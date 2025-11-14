extends CharacterBody2D
class_name Projectile

const SPEED = 500

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var move_vec: Vector2 = Vector2(0, 0)
var collided: bool = false

func _physics_process(delta: float) -> void:
	if is_on_ceiling() or is_on_floor() or is_on_wall():
		queue_free()
	if move_vec and not collided:
		velocity = move_vec.normalized() * SPEED
		anim.play("travel")
		
	move_and_slide()


func _on_enemy_entered(area: Area2D) -> void:
	if area.get_parent() is Skeleton_Ghost and area.name == "area_take_damage":
		area.get_parent().die()
		collided = true
		velocity = Vector2(0,0)
		anim.play("collide")
	pass # Replace with function body.


func _on_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
