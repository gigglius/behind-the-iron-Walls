extends Node3D
## Runtime appearance customization for the first-person prisoner model.

const OPTIONS := {
	"uniform": [
		{"name": "Olive", "color": Color(0.36, 0.39, 0.34)},
		{"name": "Navy", "color": Color(0.16, 0.22, 0.34)},
		{"name": "Charcoal", "color": Color(0.25, 0.26, 0.27)},
		{"name": "Brown", "color": Color(0.38, 0.29, 0.21)}
	],
	"shirt": [
		{"name": "Khaki", "color": Color(0.62, 0.58, 0.46)},
		{"name": "Grey", "color": Color(0.52, 0.54, 0.54)},
		{"name": "Cream", "color": Color(0.78, 0.74, 0.64)},
		{"name": "Blue", "color": Color(0.36, 0.47, 0.58)}
	],
	"skin": [
		{"name": "Light", "color": Color(0.78, 0.62, 0.50)},
		{"name": "Medium", "color": Color(0.68, 0.48, 0.36)},
		{"name": "Deep", "color": Color(0.39, 0.25, 0.19)}
	],
	"boots": [
		{"name": "Black", "color": Color(0.12, 0.11, 0.10)},
		{"name": "Brown", "color": Color(0.28, 0.17, 0.10)},
		{"name": "Dark grey", "color": Color(0.22, 0.23, 0.24)}
	]
}

var selected := {"uniform": 0, "shirt": 0, "skin": 1, "boots": 0}

func _ready() -> void:
	_apply_all()

func cycle_customization(category: String) -> String:
	if not OPTIONS.has(category):
		return ""
	var choices: Array = OPTIONS[category]
	selected[category] = (int(selected[category]) + 1) % choices.size()
	_apply_category(category)
	return str(choices[int(selected[category])]["name"])

func get_customization_name(category: String) -> String:
	if not OPTIONS.has(category):
		return ""
	return str(OPTIONS[category][int(selected[category])]["name"])

func _apply_all() -> void:
	for category in OPTIONS:
		_apply_category(category)

func _apply_category(category: String) -> void:
	var color: Color = OPTIONS[category][int(selected[category])]["color"]
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.92
	var node_names: Array[String] = []
	match category:
		"uniform":
			node_names = ["Torso", "LeftLeg", "RightLeg"]
		"shirt":
			node_names = ["LeftArm", "RightArm"]
		"skin":
			node_names = ["LeftHand", "RightHand"]
		"boots":
			node_names = ["LeftBoot", "RightBoot"]
	for node_name in node_names:
		var part := get_node_or_null(node_name) as MeshInstance3D
		if part != null:
			part.material_override = material
