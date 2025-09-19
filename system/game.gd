extends Node
class_name Game

static var GAME: Game
static var HUD: HUD
static var SPAWNED: Node3D
static var PLAYER: Player


func _init() -> void:
	GAME = self

func _ready() -> void:
	HUD = $HUD
	SPAWNED = $"Game3D/3DViewport/Spawned"
	PLAYER = $"Game3D/3DViewport/Player"

static func add_spawned(node: Node):
	SPAWNED.add_child(node)
