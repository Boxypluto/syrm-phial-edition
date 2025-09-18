extends Node

signal input(event: InputEvent)

func _input(event: InputEvent) -> void:
	input.emit(event)
