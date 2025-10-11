extends Label3D

@export var room: Room

func _process(delta: float) -> void:
	if room == null:
		text = "UNDEFINED ROOM"
		modulate = Color.RED
		return
	if room.is_complete:
		text = "COMPLETE"
		modulate = Color.GOLD
		return
	if room.is_active:
		text = "ACTIVE"
		modulate = Color.GREEN_YELLOW
		return
	else:
		text = "UNACTIVE"
		modulate = Color.WHITE
