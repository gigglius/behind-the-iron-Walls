extends Area3D
## Bread pickup that adds one food portion and disappears.

@export var portions: int = 1
var collected := false

func _ready() -> void:
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.45, 0.25, 0.25)
	collision.shape = shape
	add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.4, 0.2, 0.2)
	visual.mesh = mesh
	add_child(visual)

func interact(_actor: Node) -> String:
	if collected:
		return ""
	collected = true
	var food := get_tree().current_scene.get_node("FoodSystem")
	food.collect(portions)
	queue_free()
	return "You collected a bread portion."
