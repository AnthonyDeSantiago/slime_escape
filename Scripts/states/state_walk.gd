extends State
class_name State_Walk

var player: Player
var anim_sprite: AnimationPlayer
var sprite: AnimatedSprite2D

var COYOTE_TIME: float = 0.2
var coyote_time: float = 0.0


func Enter():
	super.Enter()
	player = get_node(initializer.references["player"])
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("walk")
	sprite = get_node(initializer.references["sprite"])

func Exit():
	super.Exit()
	initializer.values["previous_velocity"] = player.velocity
	anim_sprite.stop()
	
func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	if not player.isGrounded and not player.is_on_wall():
		emit_signal("Transitioned", self, "State_Fall")
	if not Input.is_anything_pressed():
		emit_signal("Transitioned", self, "State_Idle")
	
	if player.isGrounded and Input.is_action_just_pressed("jump"):
		player.velocity.y = player.JUMP_SPEED - 100 * player.jump_amount
		player.jump_amount += 1
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		player.velocity.x = player.SPEED * delta * direction
		if direction < 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		player.velocity.x = 0
	pass
