extends Resource
class_name Seqence

const PATTERN_REGEX: String = "(?<repitition>\\d*)(?<pattern>\\[(?:(?:[^][]*|(?R))*)\\])"
const NOTE_REGEX: String = "[A-G]((?<=[ACDFG])#)?\\d*|S"
const TRIM_EXTRA_SPACE_REGEX = "(?<= )\\s+|\\v+|( +$)|(^ +)"
const MULTIPLIER_REGEX: String = "^x(\\d+\\.?\\d*|\\.\\d+)"

static var patterns: RegEx = RegEx.create_from_string(PATTERN_REGEX)
static var notes: RegEx = RegEx.create_from_string(NOTE_REGEX)
static var trimmed: RegEx = RegEx.create_from_string(TRIM_EXTRA_SPACE_REGEX)
static var multiplier: RegEx = RegEx.create_from_string(MULTIPLIER_REGEX)

var tracks: int

class Instruction:
	var length: float 
	var note: Note

static func build(seqences: Array[String]):
	var sequence: Seqence = Seqence.new()
	sequence.tracks = seqences.size()

static var example = "x0.5 A B C 3[A B] [A B C] [E A# [D# C [B C C A C] [A A A]]]"
static var digits: PackedStringArray = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

class SequencePart:
	pass

static func _build_single(seqence_string: String):
	var multiplier_match: PackedStringArray = multiplier.search(seqence_string).strings
	var multiplier_number: float = multiplier.search(seqence_string).strings[0].substr(1).to_float() if not multiplier_match.is_empty() else 1.0
	var cleaned: String = trimmed.sub(seqence_string, "", true)
	print(multiplier_number)
