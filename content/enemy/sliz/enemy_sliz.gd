extends Node3D
class_name EnemySliz

@onready var animation: AnimatedSprite3D = $Animation
@onready var shoot_point: Marker3D = $ShootPoint

@export var beat_offset: int = 0
@export var shoot_velocity: float = 5.0
var target: Node3D

signal beat_action(beat: float)

const SIMPLE_PROJECTILE = preload("uid://b3lqj7yowmppk")

func _ready() -> void:
	var rhythm_beat: Signal = Rhythm.beats(2.0, true, -1.0 - beat_offset)
	rhythm_beat.connect(beat)
	rhythm_beat.connect(func(beat: float): beat_action.emit(beat))

func beat(beat_number: int):
	shoot()
	animation.play()

func shoot():
	var projectile: ProjectileSimple = SIMPLE_PROJECTILE.instantiate()
	Game.add_spawned(projectile)
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	projectile.global_position = shoot_point.global_position
	projectile.direction = projectile.global_position.direction_to(Game.PLAYER.global_position)
	projectile.speed = shoot_velocity
	projectile.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT
