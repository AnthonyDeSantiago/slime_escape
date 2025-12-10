extends CanvasLayer
@onready var pause_menu: MarginContainer = $Pause_Menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()
	pass

func pause_game():
	if get_tree().paused:
		pause_menu.visible = false
		get_tree().paused = false
	else:
		pause_menu.visible = true
		get_tree().paused = true


func _on_button_continue_pressed() -> void:
	get_parent().get_tree().paused = false
	pause_menu.visible = false
	pass # Replace with function body.


func _on_button_restart_pressed() -> void:
	get_parent().get_tree().paused = false
	get_tree().reload_current_scene()
