extends WeaponState
class_name OrbState

@onready var player: Player = $"../.."
@onready var sfx_shoot: MusicalAudioGlobal = $"../../SFX/Orb/Shoot"
@onready var sfx_fail: MusicalAudioGlobal = $"../../SFX/Orb/Fail"

var required_beat: float = 1.0
var leeway: float = 0.2

func _ready() -> void:
	pass
	#Rhythm.beats(1).connect(weapon_input)

func weapon_input(beat: int = 0) -> void:
	
	var distance_from_beat: float = distance_from_closest_beat(Rhythm.get_decimal_beat(), required_beat)
	
	if distance_from_beat <= leeway:
		attack_action()
	else:
		sfx_fail.play_musical(Rhythm.current_beat)
		Game.HUD.GUN.find_child("Orb").fail()

func distance_from_closest_beat(test_position: float, beat_interval: float):
	var wrapped_position: float = fmod(test_position, beat_interval)
	var distance_from_next: float = beat_interval - wrapped_position
	return minf(wrapped_position, distance_from_next)

func attack_action() -> void:
	
	var shoot_result: Player.ShootResult = player.shoot_forward()
	
	sfx_shoot.play_musical(Rhythm.current_beat)
	Game.HUD.GUN.shoot()
	if player.is_on_floor():
		player.camera.shake(0.2, 0.1)
	player.particles_from_result(shoot_result, player.camera.SHOOT_POINT_ORB.global_position, 0.7)
	
	if shoot_result.hit_hitbox():
			#Freeze.freeze(0.05)
			shoot_result.hit_object.hit.emit()
