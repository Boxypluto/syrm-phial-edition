extends RoomEntity
class_name EnemyLenzen

@onready var laser_point: Marker3D = $LaserPoint
@export var sequence: Seqence
@onready var health: Health = $Health

var laser_arc_width: float = 20.0

var laser: Node3D
var laser_angle: Vector3
var laser_target: Vector3
var target_distance: float

const CHARGE_EFFECT = preload("uid://c5afmmte8jjns")
const LENZEN_LASER = preload("uid://bam70ys1vxtwk")

@onready var sfx_charge: MusicalAudio3D = $SFX/Charge
@onready var sfx_fire: MusicalAudio3D = $SFX/Fire

enum {
	IDLE,
	CHARGING,
	FIRING,
}

var state: int = IDLE

func room_load() -> void:
	sequence.setup_exported()
	sequence.tracks[0].note_played.connect(func(_a, _b, note: Note):
		if not Debug.flags.get("lenzen"): return
		if not is_room_active: return
		charge_laser(note))
	sequence.tracks[1].note_played.connect(func(_a, _b, note: Note):
		if not Debug.flags.get("lenzen"): return
		if not is_room_active: return
		fire_laser(note))
	sequence.tracks[2].note_played.connect(func(_a, _b, note: Note):
		if not Debug.flags.get("lenzen"): return
		end_laser(note))
	
	Rhythm.beats(0.125).connect(func(_b):
		if not Debug.flags.get("lenzen"): return
		change_effect())
	
	laser = LENZEN_LASER.instantiate()
	set_laser(false)
	add_child(laser)
	laser.position = laser_point.position

func physics_update(delta: float) -> void:
	if state == FIRING:
		if laser.rotation == laser_target: pass
		set_laser(true)
		
		var target_basis: Basis = Basis.looking_at(laser_target)
		
		var current: Quaternion = global_transform.basis.get_rotation_quaternion()
		var target: Quaternion = target_basis.get_rotation_quaternion()
		
		var new: Quaternion = current.slerp(target, delta * 1.0)
		
		global_transform.basis = Basis(new)
		#laser.rotation = laser.rotation.move_toward(laser_target, delta * 120.0 / (target_distance * TAU))

func charge_laser(note: Note):
	sfx_charge.play_note(note)
	print("CHARGE")
	if state == FIRING: return
	state = CHARGING

func fire_laser(note: Note):
	sfx_fire.play_note(note)
	set_laser(false)
	print("FIRE")
	var laser_pos: Vector2 = Vector.flatten(laser.global_position) * Vector2(1, -1)
	var player_pos: Vector2 = Vector.flatten(Game.PLAYER.global_position) * Vector2(1, -1)
	var dir_to_player: Vector2 = laser_pos.direction_to(player_pos)
	
	var left_dir: Vector2 = dir_to_player.rotated(-PI/4.0)
	var right_dir: Vector2 = dir_to_player.rotated(PI/4.0)
	
	var left_pos: Vector2 = player_pos + left_dir * laser_arc_width
	var right_pos: Vector2 = player_pos + right_dir * laser_arc_width
	
	var left_target: Vector3 = Vector.two_to_three(left_pos * Vector2(1, -1), Game.PLAYER.global_position.y)
	var right_target: Vector3 = Vector.two_to_three(right_pos * Vector2(1, -1), Game.PLAYER.global_position.y)
	
	laser_target = laser.global_position.direction_to(right_target)
	laser.look_at(left_target)
	
	target_distance = laser.global_position.distance_to(Game.PLAYER.global_position)
	
	state = FIRING
	set_laser(true)

func end_laser(note: Note):
	print("END")
	set_laser(false)
	state = IDLE

func change_effect():
	if state != CHARGING: return
	var charge: Node3D = CHARGE_EFFECT.instantiate()
	charge.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	Game.add_spawned(charge)
	charge.global_position = laser_point.global_position
	charge.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func set_laser(on: bool):
	laser.visible = on
	laser.set_process(on)
	laser.set_physics_process(on)

func on_zero_health() -> void:
	queue_free()

func on_hit(damage: DamageInfo) -> void:
	health.damage(damage.damage)
