extends Node3D
class_name Room

var _entities: Array[RoomEntity]

@export_category("Doors")

@export_category("Settings")
@export var auto_clear: bool = false
@export var first_room: bool = false

var is_active: bool = false:
	set(new):
		is_active = new
		for entity in _entities:
			entity.is_room_active = new
var is_complete: bool = false
var doors: Array[Door]

func _ready() -> void:
	var e = find_children("*", "RoomEntity")
	for en in e:
		_entities.append(en)
	load_room()
	if first_room:
		begin_room()

func room_enter():
	if is_active: return
	if not is_complete:
		begin_room()

func room_exit():
	if not is_active: return

func _process(delta: float) -> void:
	if is_active:
		for entity in _entities:
			entity.frame_update(delta)

func _physics_process(delta: float) -> void:
	if is_active:
		for entity in _entities:
			entity.physics_update(delta)

func load_room() -> void:
	for entity in _entities:
		entity.room_load()

func begin_room() -> void:
	is_active = true
	for entity in _entities:
		entity.room_begin()
	for door in doors:
		door.active = true
	if auto_clear:
		complete_room()

func complete_room() -> void:
	is_complete = true
	for entity in _entities:
		entity.room_complete()
	for door in doors:
		door.active = false
		door.active = false
