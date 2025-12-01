extends State
class_name State_Fall

var anim_sprite: AnimationPlayer
var player: Player

func Enter():
	super.Enter()
	anim_sprite = get_node(initializer.references["anim_sprite"])
	anim_sprite.play("wall_slide")
	player = get_node(initializer.references["player"])

func Exit():
	super.Exit()
	anim_sprite.stop()
	
func Physics_Update(_delta: float):
	pass
	
func Update(_delta: float) -> void:
	if player.isGrounded:
		emit_signal("Transitioned", self, "State_Idle")
		
	pass
