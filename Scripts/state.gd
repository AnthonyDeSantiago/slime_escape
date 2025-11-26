extends Node2D
class_name State

var initializer: State_Initializer

signal Transitioned

func Enter():
	var state_machine: State_Machine = get_parent()
	Transitioned.connect(state_machine.on_child_transition)
	state_machine.set_current_state(self)
	pass

func Exit():
	pass
	
func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func set_initializer(init: State_Initializer):
	initializer = init
