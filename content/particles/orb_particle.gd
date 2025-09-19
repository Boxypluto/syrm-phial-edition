extends Sprite3D
class_name ParticleOrb

static func spawn() -> ParticleOrb:
	var particle: ParticleOrb = ParticleOrb.new()
	particle.texture = preload("uid://dd2m01gccnken")
	particle.pixel_size = 0.05
	particle.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	particle.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	Game.add_spawned(particle)
	return particle

func _process(delta: float) -> void:
	modulate.a -= delta
	if modulate.a <= 0.0:
		queue_free()
