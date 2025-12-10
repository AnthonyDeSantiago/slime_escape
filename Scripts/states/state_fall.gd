extends State
class_name State_Fall

var anim_sprite: AnimationPlayer
var player: Player
var init: bool = false

func Enter():
	super.Enter()
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("wall_slide")
	player = get_node(initializer.references["player"])
	player.velocity = initializer.values["previous_velocity"]

func Exit():
	super.Exit()
	anim_sprite.stop()
	
func Update(_delta: float):
	pass
	
func Physics_Update(delta: float) -> void:
	if player.isGrounded:
		emit_signal("Transitioned", self, "State_Idle")
	if !player.is_on_floor() and player.velocity.y > 0 and player.is_on_wall():
		emit_signal("Transitioned", self, "State_Wall_Sliding")
	
	if Input.is_action_just_pressed("jump") and player.jump_amount < 2:
		player.velocity.y = player.JUMP_SPEED - 100 * player.jump_amount
		player.jump_amount += 1
	
	var direction = Input.get_axis("left", "right")

	if direction:
		player.velocity.x = direction * player.SPEED_AIR * delta
		if direction < 0:
			player.animatedSprite.flip_h = false
		else:
			player.animatedSprite.flip_h = true
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, 1)
		pass
