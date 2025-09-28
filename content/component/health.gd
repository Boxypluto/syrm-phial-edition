extends Node
class_name Health

@export var current_health: float = 10.0
@export var max_health: float = 10.0

signal on_damaged_zero
signal on_healed_max

func damage(damage_amount: float):
	if damage_amount == 0: return
	current_health -= damage_amount
	
	if current_health <= 0:
		current_health = 0
		on_damaged_zero.emit()

func change(amount: float):
	if amount == 0: return
	current_health += amount
	if current_health >= max_health:
		current_health = max_health
		on_healed_max.emit()
