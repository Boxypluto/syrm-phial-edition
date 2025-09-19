extends CharacterBody3D
class_name Player

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: MainCamera = $CameraPivot/PlayerCamera

var speed: float = 10.0
var jump_strength: float = 10.0
var gravity: float = 20.0

var mouse_sensitivity: float = 3.0
var forward_direction: Vector3 = Vector3.FORWARD
var flat_forward_direction: Vector2 = Vector2.DOWN
var flat_angle: float = 0.0

var shoot_hit_layer: int = 0b11111

const SHOOT_RAY_DISTANCE: float = 128.0

func _ready() -> void:
	In.input.connect(input)
	Rhythm.beats(1, true, -1).connect(func(beats): camera.shake(0.1, 0.1))

func get_move_input():
	return Input.get_vector("Leftward", "Rightward", "Forward", "Backward").rotated(flat_angle)

func _physics_process(delta: float) -> void:
	
	run_process(delta)
	gravity_process(delta)
	jump_process(delta)
	
	shoot_process(delta)
	
	move_and_slide()

func input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Move the camera based on mouse movement
		camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity * 0.001
		camera_pivot.rotation.y -= event.relative.x * mouse_sensitivity * 0.001
		
		# Stop the camera from flipping upside-down
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -PI/2.0, PI/2.0)
		
		forward_direction = Vector3.FORWARD.rotated(Vector3.RIGHT, camera_pivot.rotation.x).rotated(Vector3.UP, camera_pivot.rotation.y)
		flat_forward_direction = Vector2.from_angle(camera_pivot.rotation.y)
		flat_angle = -camera_pivot.rotation.y

func run_process(_delta: float):
	velocity = Vector.two_to_three(get_move_input() * speed, velocity.y)

func gravity_process(delta: float):
	velocity.y -= gravity * delta

func jump_process(_delta: float):
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_strength

func camera_process(_delta):
	pass

func shoot_process(_delta):
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query_server = PhysicsRayQueryParameters3D
	
	if Input.is_action_just_pressed("Shoot"):
		
		Game.HUD.GUN.shoot()
		
		if is_on_floor():
			camera.shake(0.2, 0.1)
		
		var query: PhysicsRayQueryParameters3D = query_server.create(camera_pivot.global_position, camera_pivot.global_position + forward_direction * SHOOT_RAY_DISTANCE)
		query.collision_mask = shoot_hit_layer
		query.collide_with_areas = true
		
		var result = space_state.intersect_ray(query)
		if result:
			var collider = result.collider
			var ray_position = result.position
			if collider is HitBox:
				Freeze.freeze(0.1)
				collider.hit.emit()
			if ray_position is Vector3:
				draw_shot_particles(camera.SHOOT_POINT_ORB.global_position, ray_position, 0.4)
			else:
				draw_shot_particles(camera.SHOOT_POINT_ORB.global_position, camera_pivot.global_position + forward_direction * SHOOT_RAY_DISTANCE, 0.4, 2)
		else:
			draw_shot_particles(camera.SHOOT_POINT_ORB.global_position, camera_pivot.global_position + forward_direction * SHOOT_RAY_DISTANCE, 0.4, 2)

func draw_shot_particles(start: Vector3, end: Vector3, interval: float = 0.2, start_offset: float = 0.0):
	
	var distance: float = start.distance_to(end)
	var direction: Vector3 = start.direction_to(end)
	var current_distance: float = 0.0
	
	if interval <= 0.0: return
	if start_offset > 0.0:
		current_distance += start_offset
	
	while current_distance <= distance:
		var particle: ParticleOrb = ParticleOrb.spawn()
		particle.global_position = direction * current_distance + start
		current_distance += interval
