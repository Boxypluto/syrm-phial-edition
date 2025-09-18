extends AnimatedSprite2D
class_name GunHud

func shoot():
	animation = "Shoot"
	frame = 0
	play()

func _process(delta: float) -> void:
	if animation == "Shoot" and not is_playing():
		animation = "Idle"
