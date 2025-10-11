@abstract
extends Node3D
class_name RoomEntity

var room: Room
var is_room_active: bool = false

func physics_update(delta: float) -> void: pass
func frame_update(delta: float) -> void: pass

func room_load() -> void: pass
func room_begin() -> void: pass
func room_complete() -> void: pass
