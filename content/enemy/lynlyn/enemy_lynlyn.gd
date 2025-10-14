extends RoomEnemy

@onready var body: CharacterBody3D = $Body
@onready var agent: NavigationAgent3D = $Body/Agent
@onready var animation: AnimatedSprite3D = $Body/Animation
@onready var health: Health = $Health
@onready var damager_shape: CollisionShape3D = $Body/Damager/CollisionShape3D

@export var leap_sequence: Seqence
@export var leap_beat_interval: float = 2.0

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
	Rhythm.beats(leap_beat_interval, true, leap_beat_interval / 4.0).connect(func(_a):
		if not should_be_active(): return
		prepare_lunge())
	Rhythm.beats(leap_beat_interval, true, leap_beat_interval / 2.0).connect(func(_a):
		if not should_be_active(): return
		lunge())

func physics_update(delta: float) -> void:
	agent.get_next_path_position()
	body.velocity = body.global_position
	body.velocity = body.velocity.lerp(current_target, 1.0 -(0.01**delta))
	body.velocity -= body.global_position
	body.velocity /= delta
	body.move_and_slide()
	
	if body.global_position.distance_to(current_target) < 0.7 and not damager_shape.disabled:
		damager_shape.disabled = true
		
	if body.global_position.distance_to(current_target) < 0.7 and animation.animation == "Lunge":
		animation.play("Idle")
	animation.position.y = sin(clampf(body.global_position.distance_to(current_target) / (last_leap_start.distance_to(current_target) - 1), 0.0, 1.0)*PI) * 1.5

func prepare_lunge():
	animation.play("Prepare")

func lunge():
	damager_shape.disabled = false
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

func on_hit(damage: DamageInfo) -> void:
	health.damage(damage.damage)

func on_zero_health() -> void:
	damager_shape.disabled = true
	is_defeated = true
	visible = false
	defeated.emit()

func should_be_active() -> bool:
	return is_room_active and Debug.flags.get("lynlyn") and not is_defeated
