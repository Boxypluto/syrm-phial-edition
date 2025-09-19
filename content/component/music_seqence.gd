extends Resource
class_name MusicalSeqence

var sequence_string: String = ""
@export var sequence: Array[Note]

func _init() -> void:
	pass
	
func add_note(note: Note):
	sequence.append(note)
