extends TextureRect
class_name HurtEffect

func do_effect() -> void:
	modulate.a = 1.0

func _process(delta: float) -> void:
	if modulate.a != 0:
		modulate.a = move_toward(modulate.a, 0.0, delta * 5.0)
