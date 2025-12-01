extends State

class_name State_Idle

var player: Player
var anim_sprite: AnimationPlayer

func Enter():
	super.Enter()
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("idle")
	player = get_node(initializer.references["player"])
	player.velocity = Vector2.ZERO
	pass

func Exit():
	super.Exit()
	pass
	
func Physics_Update(_delta: float):
	pass
	
func Update(delta: float) -> void:
	if not player.isGrounded and player.velocity.y > 0:
		emit_signal("Transitioned", self, "State_Fall")
		
	if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		emit_signal("Transitioned", self, "State_Walk")
		
	if player.isGrounded and Input.is_action_just_pressed("jump"):
		player.velocity.y = player.JUMP_SPEED - 100 * player.jump_amount
		
