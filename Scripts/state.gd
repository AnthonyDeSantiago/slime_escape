extends Node2D
class_name State

var initializer: State_Initializer = State_Initializer.new()

signal Transitioned

func Enter():
	pass

func Exit():
	pass
	
func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass

func set_initializer(init: State_Initializer):
	initializer = init
