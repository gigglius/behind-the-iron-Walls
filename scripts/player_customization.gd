extends Node3D
## Appearance data and mesh updates shared by the player and creator preview.

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
	],
	"hair_style": [
		{"name": "Short", "node": "HairShort"},
		{"name": "Side part", "node": "HairPart"},
		{"name": "Buzz cut", "node": "HairBuzz"}
	],
	"hair_color": [
		{"name": "Dark brown", "color": Color(0.12, 0.075, 0.045)},
		{"name": "Black", "color": Color(0.035, 0.03, 0.025)},
		{"name": "Sandy", "color": Color(0.48, 0.34, 0.18)},
		{"name": "Auburn", "color": Color(0.35, 0.12, 0.055)}
	],
	"face": [
		{"name": "Clean shaven", "node": "FaceClean"},
		{"name": "Moustache", "node": "FaceMoustache"},
		{"name": "Stubble", "node": "FaceStubble"}
	],
	"accessory": [
		{"name": "None", "node": "AccessoryNone"},
		{"name": "Glasses", "node": "AccessoryGlasses"},
		{"name": "Cap", "node": "AccessoryCap"}
	]
}

var selected := {
	"uniform": 0, "shirt": 0, "skin": 1, "boots": 0,
	"hair_style": 0, "hair_color": 0, "face": 0, "accessory": 0
}

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

func apply_selection_dictionary(values: Dictionary) -> void:
	for category in OPTIONS:
		if values.has(category):
			selected[category] = clampi(int(values[category]), 0, OPTIONS[category].size() - 1)
	_apply_all()

func _apply_all() -> void:
	for category in OPTIONS:
		_apply_category(category)

func _set_material_color(node_names: Array, color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = 0.92
	for node_name in node_names:
		var part := get_node_or_null(str(node_name)) as MeshInstance3D
		if part != null:
			part.material_override = material

func _show_one(node_names: Array, selected_node: String) -> void:
	for node_name in node_names:
		var part := get_node_or_null(str(node_name))
		if part != null:
			part.visible = str(node_name) == selected_node

func _apply_category(category: String) -> void:
	var choice: Dictionary = OPTIONS[category][int(selected[category])]
	match category:
		"uniform":
			_set_material_color(["Torso", "LeftLeg", "RightLeg"], choice["color"])
		"shirt":
			_set_material_color(["LeftArm", "RightArm"], choice["color"])
		"skin":
			_set_material_color(["LeftHand", "RightHand", "Head/HeadMesh"], choice["color"])
		"boots":
			_set_material_color(["LeftBoot", "RightBoot"], choice["color"])
		"hair_color":
			_set_material_color(["Head/HairShort", "Head/HairPart", "Head/HairBuzz", "Head/HairTop"], choice["color"])
		"hair_style":
			_show_one(["Head/HairShort", "Head/HairPart", "Head/HairBuzz"], choice["node"])
		"face":
			_show_one(["Head/FaceClean", "Head/FaceMoustache", "Head/FaceStubble"], choice["node"])
		"accessory":
			_show_one(["Head/AccessoryNone", "Head/AccessoryGlasses", "Head/AccessoryCap"], choice["node"])
