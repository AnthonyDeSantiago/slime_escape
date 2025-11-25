extends State

class_name StateIdle

func Enter():
	pass
	
func Physics_Update(_delta: float):
	pass

func test():
	emit_signal("Transitioned", name.to_lower(), "statewalk")
