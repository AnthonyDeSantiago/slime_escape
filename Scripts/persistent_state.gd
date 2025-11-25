extends Node2D

class_name PersistentState

var state
var state_factory

func _ready() -> void:
	state_factory = StateFactory.new()
	change_state("idle")

func move_left():
	state.move_left()
	
func move_right():
	state.move_right()

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = state_factory.get_state(new_state_name).new()
	state.setup(Callable(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)
