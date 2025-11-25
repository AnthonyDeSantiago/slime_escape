extends Node
class_name State_Machine

@export var initial_state : State
@export var player: CharacterBody2D

var current_state : State
var states : Dictionary = {}
var initializer: State_Initializer

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			var initializer = State_Initializer.new()
			child.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)
	if initializer:
		current_state.set_initializer(initializer)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if not new_state:
		return
		
	if current_state:
		current_state.exit()
		
	new_state.enter()
