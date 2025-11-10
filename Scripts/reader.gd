@tool
extends Node
class_name Reader
@export_tool_button("Refresh Level") var my_button_action = Callable(self, "create_level")
@export var level_texture: Texture2D
@export var texture_scale: int = 2

@onready var t: Sprite2D = $BlackBlock
@onready var m: TileMapLayer = $TileMapLayer

var image: Image
var data: PackedByteArray
var height: int
var width: int
var offset: Vector2
var mult: float = 3
var start_coord: Vector2
var win_coord: Vector2
func _ready() -> void:
	#create_level()
	pass
func create_level():
	if Engine.is_editor_hint():
		EditorInterface.get_resource_filesystem().scan()
	m.clear()
	if level_texture:
		print("Refreshing Level")
		image = level_texture.get_image()
		height = image.get_height()
		width = image.get_width()
		for y in range(height):
			for x in range(width):
				var pixel = image.get_pixel(x, y)
				var position = (Vector2(x, y - 210) * 1)
				if pixel == Color.BLACK:
					m.set_cell(position, 0, Vector2(0, 0))
				if pixel == Color.RED:
					m.set_cell(position, 1, Vector2(0, 0))
					print("win_pos", position)
					win_coord = Vector2(position)
