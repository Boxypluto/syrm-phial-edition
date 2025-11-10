extends Node
class_name Game

static var GAME: Game
static var HUD: HUD
static var SPAWNED: Node3D
static var PLAYER: Player
static var LEVEL: Node
static var VIEWPORT: SubViewport

static var are_game_refrences_ready: bool = false
static var current_level_packed: PackedScene
static var time: float:
	get(): return Time.get_ticks_msec() / 1000.0

const SCENE_PLAYER = preload("uid://db6dv4pdde6co")
const SCENE_TESTING_1 = preload("uid://ccuvbsr4nryxp")
const LEVEL_BEAMBLOOM_DESERT = preload("uid://c8e2r7s0iqkyr")
const LEVEL_BEAMBLOOM = preload("uid://d3wksdk62wfdy")

signal game_refrences_ready

func restart():
	start_level(current_level_packed)

func start_level(level: PackedScene):
	if LEVEL != null:
		LEVEL.queue_free()
	if PLAYER != null:
		PLAYER.queue_free()
	
	for child in SPAWNED.get_children():
		child.queue_free()
	
	LEVEL = level.instantiate()
	VIEWPORT.add_child(LEVEL)
	current_level_packed = level
	
	PLAYER = SCENE_PLAYER.instantiate()
	VIEWPORT.add_child(PLAYER)
	PLAYER.global_position = Vector3(0, 2, 0)

func _init() -> void:
	GAME = self

func _ready() -> void:
	HUD = $HUD
	SPAWNED = $"Game3D/3DViewport/Spawned"
	VIEWPORT = $"Game3D/3DViewport"

static func add_spawned(node: Node):
	SPAWNED.add_child(node)

static func timer(start_time: float, timer_length: float) -> bool:
	return (Time.get_ticks_msec() / 1000.0 - start_time) >= timer_length


func _on_start_button_pressed() -> void:
	start_level(LEVEL_BEAMBLOOM_DESERT)
	
	are_game_refrences_ready = true
	game_refrences_ready.emit()
	$StartButton.queue_free()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
