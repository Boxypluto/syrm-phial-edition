extends Control
class_name HUD

@onready var GUN: GunHud = $Gun
@onready var HURT: HurtEffect = $Hurt
@onready var BEAT_SYNCER: BeatSyncer = $BeatSyncer/Beats
@onready var BEAT_SYNCER_ALT: BeatSyncer = $BeatSyncer/BeatsAlt

@onready var ORB_CENTER: Marker2D = $Gun/Orb/Center
@onready var DIALOUGE: Control = $DIALOUGE
