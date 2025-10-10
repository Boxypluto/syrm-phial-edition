extends AnimatedSprite3D
class_name HitEffect

const HIT_FRAMES = preload("uid://g26vi8ruwykt")

func _ready() -> void:
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sprite_frames = HIT_FRAMES
	animation = "Hit"
	frame = animation.length()

func do_effect(_damage: DamageInfo):
	frame = 0
	play()
