@tool
extends Node
@export_tool_button("Click Me!") var my_button_action = Callable(self, "my_function")
@export var level_texture: Texture2D

@onready var t: Sprite2D = $BlackBlock
@onready var m: TileMapLayer = $TileMapLayer

var image: Image
var data: PackedByteArray
var height: int
var width: int
var offset: Vector2
func _ready() -> void:
	if level_texture:
		image = level_texture.get_image()
		height = image.get_height()
		width = image.get_width()
		offset = Vector2(-width / 2, height / 2)
	m.set_cell(Vector2(0,0), 0, Vector2(0,0))
	pass

func _process(delta: float) -> void:
	pass

func create_level():
	
func my_function():
	pass
