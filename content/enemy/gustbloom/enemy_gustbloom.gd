extends Node3D
class_name EnemyGustbloom

@onready var vertical_gusts_node: Node3D = $VerticalGusts
@onready var spiral_gusts_node: Node3D = $SpiralGusts

const GUST = preload("uid://ca4tm6hy5mb31")

var spiral_count: int = 3
var spiral_gust_count: int = 6
var vertical_gust_count: int = 5

var sprial_rotation_speed: float = 1.5 

var spiral_gusts_seperation: float = 2.0
var spiral_y_position: float = 1.0
var spiral_drag: float = 0.1

var vertical_gusts_seperation: float = 2.7
var veritcal_gusts_y_position: float = 4.0

var vertical_gusts: Array[Node3D]
var spirals: Array[Array]
var all_gusts: Array[Node3D]

var spirals_rotation: float = 0.0
var spirals_rotations: Array[float]

func _ready() -> void:
	
	spirals_rotations.resize(spiral_count)
	
	for spiral_index in range(spiral_count):
		spirals.append([])
		
		for gust_index in range(spiral_gust_count):
			var gust: Node3D = GUST.instantiate()
			gust.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
			spiral_gusts_node.add_child(gust)
			spirals[spiral_index].append(gust)
			all_gusts.append(gust)
	
	#for gust_index in range(vertical_gust_count):
	#	var gust: Node3D = GUST.instantiate()
	#	gust.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	#	vertical_gusts_node.add_child(gust)
	#	vertical_gusts.append(gust)
	#	all_gusts.append(gust)
	
	position_sprials()
	#position_verticals()
	
	for gust in all_gusts:
		gust.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func _physics_process(delta: float) -> void:
	
	spirals_rotation += delta * sprial_rotation_speed
	
	position_sprials()
	#position_verticals()

func position_sprials():
	for spiral_index: int in range(spiral_count):
		var rotation_offset: float = (float(spiral_index) / spiral_count) * TAU
		print(rotation_offset)
		
		for gust_index: int in range(spiral_gust_count):
			var gust: Node3D = spirals[spiral_index][gust_index]
			var gust_rotation: float = spirals_rotation + rotation_offset - spiral_drag * gust_index
			var normalized_position: Vector3 = Vector3(cos(gust_rotation), 0, sin(gust_rotation))
			gust.position = normalized_position * (spiral_gusts_seperation * (gust_index + 1)) + Vector3(0, spiral_y_position, 0)

func position_verticals():
	for gust_index: int in range(vertical_gust_count):
		var gust: Node3D = vertical_gusts[gust_index]
		gust.position = Vector3(0, veritcal_gusts_y_position + vertical_gusts_seperation * gust_index, 0)
