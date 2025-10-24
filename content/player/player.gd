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

var RAY_HIT_LAYER: int = 2 + 1

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

func shoot_forward() -> RayResult:
	var space_state: PhysicsDirectSpaceState3D = camera.get_world_3d().direct_space_state
	
	var viewport_center: Vector2 = camera.get_viewport().size / 2.0
	var origin: Vector3 = camera.project_ray_origin(viewport_center)
	var direction: Vector3 = camera.project_ray_normal(viewport_center)
	var end: Vector3 = origin + direction * SHOOT_RAY_DISTANCE
	
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(origin, end, RAY_HIT_LAYER)
	query.collide_with_areas = true
	
	var result: RayResult = RayResult.new(space_state.intersect_ray(query), origin, direction, SHOOT_RAY_DISTANCE)
	return result

func on_hit(damage: DamageInfo) -> void:
	Game.HUD.HURT.do_effect()
	camera.shake(0.4, 0.4)
	health.damage(damage.damage)
	#Freeze.freeze(0.2)

func bounce(area: Area3D) -> void:
	velocity.y = 20

func on_zero_health() -> void:
	Game.GAME.restart()
