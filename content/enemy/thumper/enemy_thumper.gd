extends RoomEnemy
class_name EnemyThumper

@onready var animation: AnimatedSprite3D = $Animation
@onready var sfx_thump: MusicalAudio3D = $SFX/Thump
@onready var shockwave_point: Marker3D = $ShockwavePoint
@onready var health: Health = $Health

@export var string_sequence: String
@onready var sequence: Seqence = Seqence.build([string_sequence], true)

const SHOCKWAVE_RED = preload("uid://byuxxh5o13cas")

var thump_beat: int = 4

func room_load() -> void:
	Rhythm.beats(0.5).connect(func(beat):
		if not should_be_active(): return
		next_action())
	sequence.tracks[0].note_played.connect(func(l: float, p: float, note: Note):
		if not should_be_active(): return
		next_action(note))

func next_action(note: Note = null) -> void:
	if note:
		thump(note)
	next_idle()

func next_idle() -> void:
	if animation.animation != "Idle":
		if not animation.is_playing():
			animation.animation = "Idle"
		else:
			return
	
	if animation.frame == animation.sprite_frames.get_frame_count("Idle") - 1:
		animation.frame = 0
	else:
		animation.frame += 1

func thump(note: Note) -> void:
	animation.play("Thump")
	sfx_thump.play_note(note)
	spawn_shockwave()
	

func spawn_shockwave():
	var shockwave: ShockwaveRed = SHOCKWAVE_RED.instantiate()
	Game.add_spawned(shockwave)
	shockwave.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	shockwave.global_position = shockwave_point.global_position
	shockwave.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func kill() -> void:
	is_defeated = true
	visible = false
	defeated.emit()

func on_damaged(damage: DamageInfo) -> void:
	health.damage(damage.damage)

func should_be_active() -> bool:
	return is_room_active and Debug.flags.get("thumper") and not is_defeated
