extends Node2D
class_name GunHud

@onready var orb: WeaponOrb = $Orb

func shoot():
	orb.shoot()
