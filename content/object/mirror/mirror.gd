extends Node3D

@onready var player_decal: Decal = $PlayerDecal

func _physics_process(delta: float) -> void:
	player_decal.global_position = Game.PLAYER.global_position
