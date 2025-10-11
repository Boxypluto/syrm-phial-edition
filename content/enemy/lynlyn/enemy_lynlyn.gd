extends RoomEnemy

@onready var body: CharacterBody3D = $Body
@onready var agent: NavigationAgent3D = $Body/Agent
@onready var animation: AnimatedSprite3D = $Body/Animation

@export var leap_sequence: Seqence

@export var note: String = "A"

@onready var sfx_leap: MusicalAudio3D = $Body/SFX/Leap

var current_target: Vector3
var leap_distance: float = 16.0
var last_leap_start: Vector3

func room_load() -> void:
	leap_sequence.setup_exported()
	last_leap_start = body.global_position
	assert(room.navmesh != null, "LynLyn's Room does not have a Connected NavigationRegion3D!")

func room_begin() -> void:
	update_path()
	Rhythm.beats(2.0, true, 0.5).connect(func(_a): prepare_lunge())
	Rhythm.beats(2.0, true, 1.0).connect(func(_a): lunge())

func physics_update(delta: float) -> void:
	agent.get_next_path_position()
	body.velocity = body.global_position
	body.velocity = body.velocity.lerp(current_target, 1.0 -(0.01**delta))
	body.velocity -= body.global_position
	body.velocity /= delta
	body.move_and_slide()
	
	if body.global_position.distance_to(current_target) < 0.7 and animation.animation == "Lunge":
		animation.play("Idle")
	animation.position.y = sin(clampf(body.global_position.distance_to(current_target) / (last_leap_start.distance_to(current_target) - 1), 0.0, 1.0)*PI) * 1.5

func prepare_lunge():
	animation.play("Prepare")

func lunge():
	animation.play("Lunge")
	sfx_leap.play_note(leap_sequence.next(Rhythm.current_beat).note)
	last_leap_start = body.global_position
	update_path()

func update_path() -> void:
	agent.target_position = Game.PLAYER.global_position
	current_target = agent.get_next_path_position()
	current_target = (current_target - body.global_position).normalized().rotated(Vector3.UP, randf_range(-0.2, 0.2)) * leap_distance + body.global_position
	
	var region_rid: RID = room.navmesh.get_region_rid()
	current_target = NavigationServer3D.region_get_closest_point(region_rid, current_target)
