extends Node3D
class_name EnemyThumper

@onready var animation: AnimatedSprite3D = $Animation
@onready var sfx_thump: MusicalAudio3D = $SFX/Thump
@onready var shockwave_point: Marker3D = $ShockwavePoint

@export var beat_offset: float = 0.0

const SHOCKWAVE_RED = preload("uid://byuxxh5o13cas")

var thump_beat: int = 4

func _ready() -> void:
	Rhythm.beats(1).connect(next_action)

func next_action(beat: float) -> void:
	if int(beat) % thump_beat == 0:
		thump(int(beat))
	else:
		next_idle(beat)

func next_idle(beat: float) -> void:
	if animation.animation != "Idle":
		if not animation.is_playing():
			animation.animation = "Idle"
		else:
			return
	
	if animation.frame == animation.sprite_frames.get_frame_count("Idle") - 1:
		animation.frame = 0
	else:
		animation.frame += 1

func thump(beat: int) -> void:
	animation.play("Thump")
	sfx_thump.play_musical(beat, int(beat_offset))
	spawn_shockwave()
	

func spawn_shockwave():
	var shockwave: ShockwaveRed = SHOCKWAVE_RED.instantiate()
	Game.add_spawned(shockwave)
	shockwave.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	shockwave.global_position = shockwave_point.global_position
	shockwave.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
