extends Node
class_name Game

static var GAME: Game
static var HUD: HUD

func _init() -> void:
	GAME = self

func _ready() -> void:
	HUD = $HUD
