extends WeaponState
class_name OrbState

@onready var player: Player = $"../.."
@onready var sfx_shoot: MusicalAudioGlobal = $"../../SFX/Orb/Shoot"
@onready var sfx_fail: MusicalAudioGlobal = $"../../SFX/Orb/Fail"

@export_multiline var string_sequence: String
@onready var sequence: Seqence
@export_multiline var charge_string_sequence: String
@onready var charge_sequence: Seqence

var required_beat: float = 1.0
var leeway: float = 0.2
var delay: float = 0.11
@export var damage: DamageInfo

func _ready() -> void:
	sequence = Seqence.build([string_sequence], true)
	charge_sequence = Seqence.build([charge_string_sequence], true)
	
	if not Game.are_game_refrences_ready: await Game.GAME.game_refrences_ready
	
	Game.HUD.BEAT_SYNCER.beats_sequence = sequence
	Game.HUD.BEAT_SYNCER.setup()
	Game.HUD.BEAT_SYNCER_ALT.beats_sequence = charge_sequence
	Game.HUD.BEAT_SYNCER_ALT.setup()

func weapon_input() -> void:
	
	var next_distance: float = sequence.next((Rhythm.current_position - delay) / Rhythm.beat_length - leeway / 2.0).note_distance * Rhythm.beat_length
	
	if next_distance <= leeway:
		attack_action()
	else:
		sfx_fail.play()
		Game.HUD.GUN.find_child("Orb").fail()

func distance_from_closest_beat(test_position: float, beat_interval: float):
	var wrapped_position: float = fmod(test_position, beat_interval)
	var distance_from_next: float = beat_interval - wrapped_position
	return minf(wrapped_position, distance_from_next)

func attack_action() -> void:
	
	var shoot_result: Player.ShootResult = player.shoot_forward()
	
	if shoot_result.hit_hitbox():
		shoot_result.hit_object.on_hit(damage)
	
	var note: Note = sequence.next((Rhythm.current_position - delay) / Rhythm.beat_length - leeway / 2.0, 0).note
	sfx_shoot.play_note(note)
	Game.HUD.GUN.shoot()
	if player.is_on_floor():
		player.camera.shake(0.2, 0.1)
	player.particles_from_result(shoot_result, player.camera.SHOOT_POINT_ORB.global_position, 0.7)
