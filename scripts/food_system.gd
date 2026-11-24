extends Node
## Lightweight food meter. Starvation is a gentle checkpoint reset, not graphic harm.

signal food_changed(portions: int)
signal needs_food

@export var starting_portions: int = 3
var portions: int

func _ready() -> void:
	portions = starting_portions
	food_changed.emit(portions)

func eat() -> bool:
	if portions <= 0:
		needs_food.emit()
		return false
	portions -= 1
	food_changed.emit(portions)
	if portions == 0:
		needs_food.emit()
	return true

func collect(amount: int = 1) -> void:
	portions = max(0, portions + amount)
	food_changed.emit(portions)
