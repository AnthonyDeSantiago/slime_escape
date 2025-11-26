extends State

class_name State_Idle

var player: Player
var anim_sprite: AnimationPlayer

func Enter():
	super.Enter()
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("idle")
	player = get_node(initializer.references["player"])
	pass

func Exit():
	super.Exit()
	pass
	
func Physics_Update(_delta: float):
	pass
	
func Update(delta: float) -> void:
	if not player.isGrounded and player.velocity.y > 0:
		emit_signal("Transitioned", self, "State_Fall")
		
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		emit_signal("Transitioned", self, "State_Walk")
		
