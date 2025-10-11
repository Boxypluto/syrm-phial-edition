extends CharacterBody3D
class_name Player

@onready var camera_pivot: Node3D = $CameraPivot
@onready var camera: MainCamera = $CameraPivot/PlayerCamera

@onready var sfx_step: AudioStreamPlayer = $SFX/Step

@onready var state_orb: OrbState = $WeaponStates/Orb

@onready var health: Health = $Health

var speed: float = 15.0
var jump_strength: float = 12.0
var gravity: float = 20.0
var pound_speed: float = 128.0

var mouse_sensitivity: float = 3.0 * 5.0
var forward_direction: Vector3 = Vector3.FORWARD
var flat_forward_direction: Vector2 = Vector2.DOWN
var flat_angle: float = 0.0

var shoot_hit_layer: int = 0b11111

var on_floor_last_frame: bool = false
var last_frame_velocity: Vector3 = Vector3.ZERO

const SHOOT_RAY_DISTANCE: float = 128.0

func _ready() -> void:
	In.input.connect(input)
	Rhythm.beats(1, true, -1).connect(func(beats): camera.shake(0.1, 0.1))
	Rhythm.beats(0.25).connect(try_step)

func try_step(_beat: int = 0):
	if velocity != Vector3.ZERO and is_on_floor():
		sfx_step.play()

func get_move_input():
	return Input.get_vector("Leftward", "Rightward", "Forward", "Backward").rotated(flat_angle)

func _physics_process(delta: float) -> void:
	
	run_process(delta)
	gravity_process(delta)
	jump_process(delta)
	pound_process(delta)
	
	camera_process(delta)
	
	if not on_floor_last_frame and is_on_floor() and last_frame_velocity.y < -100.0:
		print("BAM!")
		camera.shake(0.2, 0.3)
	
	on_floor_last_frame = is_on_floor()
	last_frame_velocity = velocity
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

func pound_process(_delta: float):
	if Input.is_action_just_pressed("Pound"):
		velocity.y = -pound_speed

func camera_process(_delta):
	
	var input: Vector2 = Input.get_vector("Leftward", "Rightward", "Forward", "Backward").normalized()
	camera.rotation_goal = -input.x * 0.01

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		state_orb.weapon_input()

class ShootResult:
	var result_dict: Dictionary
	var hit_object: Node3D
	var ray_position: Vector3
	var origin: Vector3
	
	func _init(_result_dict: Dictionary, _hit_object: Node3D, _origin: Vector3, _ray_position: Vector3) -> void:
		result_dict = _result_dict
		hit_object = _hit_object
		origin = _origin
		ray_position = _ray_position
	
	func did_hit_object() -> bool:
		return hit_object != null
	
	func hit_hitbox() -> bool:
		return hit_object is HitBox

func shoot_forward():
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query_server = PhysicsRayQueryParameters3D
	
	var origin: Vector3 = camera_pivot.global_position
	var furthest_target: Vector3 = camera_pivot.global_position + forward_direction * SHOOT_RAY_DISTANCE
	var query: PhysicsRayQueryParameters3D = query_server.create(origin, furthest_target)
	query.collision_mask = shoot_hit_layer
	query.collide_with_areas = true
	
	var result: Dictionary = space_state.intersect_ray(query)
	
	if result:
		var collider: Node3D = result.collider
		var ray_position: Vector3 = result.position
		return ShootResult.new(result, collider, origin, ray_position)
	
	return ShootResult.new(result, null, origin, furthest_target)

func particles_from_result(result: ShootResult, start_position: Vector3, interval: float = 0.2) -> void:
	draw_shot_particles(start_position, result.ray_position, interval)

func draw_shot_particles(start: Vector3, end: Vector3, interval: float = 0.2, start_offset: float = 0.0) -> void:
	
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

func on_hit(damage: DamageInfo) -> void:
	Game.HUD.HURT.do_effect()
	camera.shake(0.4, 0.4)
	health.damage(damage.damage)
	#Freeze.freeze(0.2)

func bounce(area: Area3D) -> void:
	velocity.y = 20

func on_zero_health() -> void:
	Game.GAME.restart()
