extends State
class_name State_Walk

var player: Player
var anim_sprite: AnimationPlayer
var sprite: AnimatedSprite2D

func Enter():
	super.Enter()
	player = get_node(initializer.references["player"])
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("walk")
	sprite = get_node(initializer.references["sprite"])

func Exit():
	super.Exit()
	anim_sprite.stop()
	
func Physics_Update(_delta: float):
	pass

func Update(delta: float):
	if not player.isGrounded and player.velocity.y > 0:
		emit_signal("Transitioned", self, "State_Fall")
	if not Input.is_anything_pressed():
		emit_signal("Transitioned", self, "State_Idle")
	
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
