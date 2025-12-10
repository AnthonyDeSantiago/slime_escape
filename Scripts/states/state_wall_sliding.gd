extends State
class_name State_Wall_Sliding

var anim_sprite: AnimationPlayer
var player: Player

func Enter():
	super.Enter()
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("wall_slide")
	player = get_node(initializer.references["player"])
	player.jump_amount = 1

func Exit():
	super.Exit()
	anim_sprite.stop()
	initializer.values["previous_velocity"] = player.velocity
	print("vel:", initializer.values["previous_velocity"])

	
func Update(_delta: float):
	pass
	
func Physics_Update(delta: float) -> void:
	if player.isGrounded:
		emit_signal("Transitioned", self, "State_Idle")
	if not player.is_on_wall() and not player.isGrounded:
		emit_signal("Transitioned", self, "State_Fall")
		
	var direction = Input.get_axis("left", "right")
	
	if direction:
		player.velocity.x = player.SPEED * delta * direction
		if direction < 0:
			player.animatedSprite.flip_h = false
		else:
			player.animatedSprite.flip_h = true
	else:
		player.velocity.x = 0
	if !player.is_on_floor() and player.velocity.y > 0 and player.is_on_wall():
		player.wall_contact_coyote = player.WALL_CONTACT_COYOTE_TIME
		player.velocity.y = player.GRAVITY_WALL
	else:
		player.wall_contact_coyote -= delta
		
	if Input.is_action_just_pressed("jump") and player.jump_amount < 2:
		player.velocity.y = player.JUMP_SPEED - 100 * player.jump_amount
		player.wall_jump_count += 1
		player.velocity.x = player.get_wall_normal().x * player.WALL_JUMP_PUSH_FORCE
		initializer.values["previous_velocity"] = player.velocity
	pass
