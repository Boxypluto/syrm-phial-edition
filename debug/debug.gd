extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Debug_CaptureMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("Debug_UncaptureMouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
