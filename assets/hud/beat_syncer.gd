extends Node2D
class_name BeatSyncer

@export var texture_left: Texture2D
@export var texture_right: Texture2D
var beats_sequence: Seqence
var beats: Array[float]

var speed_scale: float = 32.0
var future_look: float = 32.0

signal beat_centered

var is_setup: bool = false

func setup() -> void:
	beats_sequence.setup_exported()
	beats_sequence.tracks[0].note_played.connect(func(_a, _b, _c): beat_centered.emit())
	is_setup = true

func _process(_delta: float) -> void:
	if not is_setup: return
	beats = beats_sequence.next_positions(Rhythm.current_beat, 32.0)
	queue_redraw()

enum POSITIONING {
	CENTER,
	LEFT,
	RIGHT,
}

func draw_centered(source_texture: Texture2D, texture_position: Vector2, positioning: POSITIONING = POSITIONING.CENTER):
	var size: Vector2 = source_texture.get_size()
	var centered_position: Vector2 = texture_position - (size / 2.0)
	
	if positioning == POSITIONING.RIGHT:
		centered_position.x = texture_position.x
	if positioning == POSITIONING.LEFT:
		centered_position.x = texture_position.x - size.x
	
	draw_texture_rect(source_texture, Rect2(centered_position, size), false)

func _draw() -> void:
	if not is_setup: return
	var current_beat: float = Rhythm.current_position / Rhythm.beat_length
	for beat: float in beats:
		var offset: float = max(beat - current_beat, 0.0)
		
		if offset <= 0:
			continue
			
		draw_centered(texture_left, Vector2(-offset * speed_scale, 0), POSITIONING.LEFT)
		draw_centered(texture_right, Vector2(offset * speed_scale, 0), POSITIONING.RIGHT)
