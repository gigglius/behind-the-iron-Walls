extends Node3D
## Owns the prototype's shared game state and simple scene setup.

@export var starting_food: int = 3
var food_portions: int
var checkpoint_position: Vector3 = Vector3(0, 1, 2)

func _ready() -> void:
	food_portions = starting_food
	add_to_group("game_manager")
	print("Behind the Iron Walls prototype ready. Food portions: ", food_portions)

func consume_food() -> bool:
	if food_portions <= 0:
		return false
	food_portions -= 1
	print("Food portions remaining: ", food_portions)
	return true

func add_food(amount: int = 1) -> void:
	food_portions = max(0, food_portions + amount)
	print("Food portions: ", food_portions)

func return_to_checkpoint(player: Node3D) -> void:
	if is_instance_valid(player):
		player.global_position = checkpoint_position
