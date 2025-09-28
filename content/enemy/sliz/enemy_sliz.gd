extends Node3D
class_name EnemySliz

@onready var animation: AnimatedSprite3D = $Animation
@onready var shoot_point: Marker3D = $ShootPoint
@onready var health: Health = $Health

@onready var sfx_shoot: MusicalAudio3D = $SFX/Shoot

@export_multiline var string_sequence: String
@onready var sequence: Seqence = Seqence.build([string_sequence], true)
@export var beat_offset: int = 0
@export var shoot_velocity: float = 5.0

var target: Node3D

signal beat_action(beat: float)

const SIMPLE_PROJECTILE = preload("uid://b3lqj7yowmppk")

func _ready() -> void:
	sequence.tracks[0].note_played.connect(func(length: float, pitch: float, note: Note):
		shoot(note)
		beat_action.emit(Rhythm.current_beat)
	)

func shoot(note: Note):
	animation.play("Pulse")
	sfx_shoot.play_note(note)
	var projectile: ProjectileSimple = SIMPLE_PROJECTILE.instantiate()
	Game.add_spawned(projectile)
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	projectile.global_position = shoot_point.global_position
	projectile.direction = projectile.global_position.direction_to(Game.PLAYER.global_position)
	projectile.speed = shoot_velocity
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func on_hit() -> void:
	animation.flip_h = randf() < 0.5
	animation.frame = 0
	animation.play("Pulse")

func kill():
	queue_free()
