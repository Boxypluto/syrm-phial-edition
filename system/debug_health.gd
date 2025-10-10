extends Label

func _process(delta: float) -> void:
	text = "Health: "
	if Game.PLAYER:
		text += str(Game.PLAYER.health.current_health)
