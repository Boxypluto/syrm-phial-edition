extends WeaponState
class_name OrbState

@onready var player: Player = $"../.."
@onready var sfx_shoot: MusicalAudioGlobal = $"../../SFX/Orb/Shoot"
@export var damage: DamageInfo
@export var shot_material: Material

var materials: Array[ShaderMaterial]

func weapon_input() -> void:
	return
	var result: RayResult =player.shoot_forward()
	print(result.collider)
	damage_hitbox(result.collider, damage)
	shoot_visual(result)

func shoot_visual(ray_result: RayResult):
	Game.HUD.GUN.orb.shoot()
	const RADIUS = 56
	var mat: Material = shot_material.duplicate()
	mat = mat as ShaderMaterial
	materials.append(mat)
	for direction: Vector2 in DIRECTIONS:
		Visual.ray(Game.HUD.ORB_CENTER.global_position * 2.0 + direction * RADIUS, 2.0, ray_result, 0.2, mat)

func _physics_process(delta: float) -> void:
	var index: int = -1
	for mat in materials:
		index += 1
		var opacity: float = mat.get_shader_parameter("opacity")
		opacity = clampf(opacity - delta, 0.0, 1.0)
		if opacity == 0.0:
			materials.remove_at(index)
			continue
		mat.set_shader_parameter("opacity", opacity)

static var DIRECTIONS: PackedVector2Array = [
	Vector2.UP,
	Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.LEFT,
	Vector2(1, 1).normalized(),
	Vector2(1, -1).normalized(),
	Vector2(-1, -1).normalized(),
	Vector2(-1, 1).normalized(),
]
