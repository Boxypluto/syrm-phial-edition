extends Node
class_name Game

static var GAME: Game
static var HUD: HUD
static var SPAWNED: Node3D
static var PLAYER: Player

static var are_game_refrences_ready: bool = false

signal game_refrences_ready

func _init() -> void:
	GAME = self

func _ready() -> void:
	HUD = $HUD
	SPAWNED = $"Game3D/3DViewport/Spawned"
	PLAYER = $"Game3D/3DViewport/Player"
	are_game_refrences_ready = true
	game_refrences_ready.emit()

static func add_spawned(node: Node):
	SPAWNED.add_child(node)
