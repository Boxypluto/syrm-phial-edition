class_name RayResult

var origin: Vector3
var furthest: float
var direction: Vector3
var collider: Node3D
var collider_id: int
var normal: Vector3
var position: Vector3
var face_index: int
var rid: RID
var shape: int

var _intersected: bool
var _dictionary: Dictionary

func is_intersected() -> bool:
	return _intersected

func get_dictionary() -> Dictionary:
	return _dictionary

func end_position() -> Vector3:
	print(position if _intersected else direction * furthest)
	print(_intersected)
	return position if _intersected else direction * furthest

func _init(result: Dictionary, ray_origin: Vector3, ray_direction: Vector3, ray_furthest: float = 1000.0) -> void:
	_dictionary = result
	origin = ray_origin
	furthest = ray_furthest
	direction = ray_direction
	
	if result.is_empty():
		_intersected = false
		return
	_intersected = true
	
	collider = result["collider"]
	collider_id = result["collider_id"]
	normal = result["normal"]
	position = result["position"]
	face_index = result["face_index"]
	rid = result["rid"]
	shape = result["shape"]
