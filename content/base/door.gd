extends Node3D
class_name Door

@onready var shape: CollisionShape3D = $Collision/Shape
@onready var debug_visuals: MeshInstance3D = $DebugVisuals

@export var north_room: Room
@export var south_room: Room

@onready var north_opening: Area3D = $NorthOpening
@onready var south_opening: Area3D = $SouthOpening

var active: bool = true:
	set(new):
		active = new
		shape.disabled = not new

func _physics_process(_delta: float) -> void:
	debug_visuals.visible = active

func _ready() -> void:
	north_room.doors.append(self)
	south_room.doors.append(self)

func on_entered_north(body: Node3D) -> void:
	if body is Player:
		north_room.room_enter()
		south_room.room_exit()

func on_entered_south(body: Node3D) -> void:
	if body is Player:
		south_room.room_enter()
		north_room.room_exit()
