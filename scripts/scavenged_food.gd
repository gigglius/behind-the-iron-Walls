extends Area3D
## Fictional, non-graphic emergency food pickup for the prison survival game.
@export_enum("Rat", "Cockroach") var creature_type: String = "Rat"
@export var food_value: int = 1
var collected := false

func _ready() -> void:
	monitoring = true
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 0.45
	collision.shape = shape
	add_child(collision)
	var visual := MeshInstance3D.new()
	if creature_type == "Rat":
		var mesh := SphereMesh.new()
		mesh.radius = 0.16
		mesh.height = 0.32
		visual.mesh = mesh
		visual.position.y = 0.16
	else:
		var mesh := CapsuleMesh.new()
		mesh.radius = 0.07
		mesh.height = 0.24
		visual.mesh = mesh
		visual.rotation_degrees.z = 90
		visual.position.y = 0.06
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.38, 0.29, 0.20) if creature_type == "Rat" else Color(0.22, 0.16, 0.10)
	material.roughness = 1.0
	visual.material_override = material
	add_child(visual)

func interact(_manager: Node) -> String:
	if collected:
		return ""
	collected = true
	var food_system := get_tree().current_scene.get_node_or_null("FoodSystem")
	if food_system != null:
		food_system.collect(food_value)
	queue_free()
	return "You collected a %s as an emergency ration (+%d food). Press F to eat." % [creature_type.to_lower(), food_value]
