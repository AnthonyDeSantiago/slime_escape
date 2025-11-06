extends Node2D

var start: Vector2
var end: Vector2

func _draw():
	if start and end:
		draw_dashed_line(start, end, Color.AZURE, 10, 10, true, true)
