extends Node2D

@export var sequence: Seqence
@onready var beats: BeatSyncer = $BeatSyncer/Beats
@onready var diff: Label = $Diff
var leeway: float = 0.25

var beat_times: Array[float]
var press_times: Array[float]

func _ready() -> void:
	beats.beats_sequence = sequence
	beats.setup()
	await get_tree().process_frame
	Rhythm.running = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot"):
		var current_beat: float = Rhythm.current_position / Rhythm.beat_length
		var next_distance: float = sequence.next(Rhythm.current_position / Rhythm.beat_length - leeway / 2.0).note_distance * Rhythm.beat_length
		var next_place: float = sequence.next(Rhythm.current_position / Rhythm.beat_length - leeway / 2.0).note_distance * Rhythm.beat_length
		beat_times.append(int(current_beat - (Rhythm.beat_length / 2.0)))
		press_times.append(next_distance)
		
	var sum: float = 0.0
	for index in range(beat_times.size()):
		sum += press_times[index]
	diff.text = "DELAY: " + str(sum / beat_times.size())
	
