extends Label

func _process(delta: float) -> void:
	text = "ENABLED ENEMIES:"
	text += "\nSLIZ: " + str(Debug.flags.get("sliz")) + " \t \nTHUMPER: " + str(Debug.flags.get("thumper")) + " \t \nGUSTBLOOM: " + str(Debug.flags.get("gustbloom")) + " \t \nLENZEN: " + str(Debug.flags.get("lenzen")) + ""
