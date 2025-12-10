extends Node
class_name State_Machine

@export var initial_state : State
@export var initializer: Initializer

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.set_initializer(initializer)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

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
		current_state.Exit()
		
	new_state.Enter()

func set_current_state(state: State):
	current_state = state
