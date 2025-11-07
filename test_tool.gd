@tool
extends Node

@export_tool_button("Click Me!") var my_button_action = Callable(self, "my_function")

func my_function():
	print("Button clicked!")
