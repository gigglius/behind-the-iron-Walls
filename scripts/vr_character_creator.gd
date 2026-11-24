extends Node3D
## World-space Quest character creator. Add this scene beneath an XR rig.
## Set left_controller_path/right_controller_path to the rig's XRController3D nodes.
## Add an OpenXR Bool action named "creator_select" and bind it to the Touch trigger.

@export_node_path("XRController3D") var left_controller_path: NodePath
@export_node_path("XRController3D") var right_controller_path: NodePath
@export var select_action: StringName = &"creator_select"
@export var toggle_action: StringName = &"creator_toggle"
var previous_toggle := false
@export var player_model_path: NodePath = NodePath("../../PlayerModel")

const MODEL_SCENE: PackedScene = preload("res://scenes/player/PlayerModel.tscn")
const CATEGORIES := [
	{"id": "hair_style", "title": "HAIRSTYLE"},
	{"id": "hair_color", "title": "HAIR COLOUR"},
	{"id": "face", "title": "FACE"},
	{"id": "uniform", "title": "UNIFORM"},
	{"id": "skin", "title": "SKIN TONE"},
	{"id": "accessory", "title": "ACCESSORIES"}
]

var player_model: Node
var preview_model: Node3D
var labels: Dictionary = {}
var previous_trigger := {"left": false, "right": false}
var status_label: Label3D

func _ready() -> void:
	_build_creator()
	_resolve_player_model()
	_refresh_labels()

func _resolve_player_model() -> void:
	if not player_model_path.is_empty():
		player_model = get_node_or_null(player_model_path)

func _build_creator() -> void:
	var panel := MeshInstance3D.new()
	var panel_mesh := BoxMesh.new()
	panel_mesh.size = Vector3(1.35, 1.65, 0.08)
	panel.mesh = panel_mesh
	var panel_mat := StandardMaterial3D.new()
	panel_mat.albedo_color = Color(0.075, 0.09, 0.105, 1)
	panel_mat.roughness = 1.0
	panel.material_override = panel_mat
	panel.position = Vector3(0.55, 1.35, -1.5)
	add_child(panel)

	var heading := Label3D.new()
	heading.text = "CHARACTER CREATOR"
	heading.font_size = 48
	heading.position = Vector3(0.55, 2.02, -1.43)
	heading.pixel_size = 0.0015
	add_child(heading)

	for i in range(CATEGORIES.size()):
		var category: Dictionary = CATEGORIES[i]
		_add_option_button(str(category["id"]), str(category["title"]), i)

	status_label = Label3D.new()
	status_label.text = "Point at an option and press a controller trigger"
	status_label.font_size = 22
	status_label.position = Vector3(0.55, 0.43, -1.42)
	status_label.pixel_size = 0.0015
	add_child(status_label)

	preview_model = MODEL_SCENE.instantiate()
	preview_model.position = Vector3(-0.48, 0.05, -1.25)
	preview_model.scale = Vector3.ONE * 0.82
	add_child(preview_model)
	var preview_head := preview_model.get_node_or_null("Head")
	if preview_head != null:
		preview_head.visible = true

func _add_option_button(category: String, title: String, index: int) -> void:
	var button := StaticBody3D.new()
	button.name = "Option_" + category
	button.position = Vector3(0.55, 1.72 - float(index) * 0.235, -1.39)
	button.set_meta("custom_category", category)
	var shape_node := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(0.92, 0.18, 0.08)
	shape_node.shape = shape
	button.add_child(shape_node)
	var mesh_node := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(0.92, 0.18, 0.04)
	mesh_node.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.18, 0.28, 0.34, 1)
	mesh_node.material_override = material
	button.add_child(mesh_node)
	var label := Label3D.new()
	label.text = title + ": ..."
	label.font_size = 24
	label.position = Vector3(-0.43, -0.035, -0.03)
	label.pixel_size = 0.0015
	button.add_child(label)
	add_child(button)
	labels[category] = label

func _refresh_labels() -> void:
	if player_model == null:
		return
	for category in CATEGORIES:
		var id := str(category["id"])
		if labels.has(id):
			labels[id].text = str(category["title"]) + ": " + str(player_model.get_customization_name(id))

func _process(_delta: float) -> void:
	if not visible:
		return
	var left_controller := get_node_or_null(left_controller_path) as XRController3D
	var right_controller := get_node_or_null(right_controller_path) as XRController3D
	if left_controller != null:
		var toggle_pressed := left_controller.get_float(toggle_action) > 0.7
		if toggle_pressed and not previous_toggle:
			visible = not visible
		previous_toggle = toggle_pressed
	_check_controller("left", left_controller)
	_check_controller("right", right_controller)

func _check_controller(hand: String, controller: XRController3D) -> void:
	if controller == null:
		return
	var pressed := controller.get_float(select_action) > 0.7
	if pressed and not bool(previous_trigger[hand]):
		_try_select(controller)
	previous_trigger[hand] = pressed

func _try_select(controller: XRController3D) -> void:
	var start := controller.global_position
	var finish := start + (-controller.global_transform.basis.z * 4.0)
	var query := PhysicsRayQueryParameters3D.create(start, finish)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return
	var target: Object = hit["collider"]
	if not target is Node or not target.has_meta("custom_category"):
		return
	var category := str(target.get_meta("custom_category"))
	if player_model == null or not player_model.has_method("cycle_customization"):
		status_label.text = "Player model reference not set"
		return
	player_model.cycle_customization(category)
	preview_model.call("apply_selection_dictionary", player_model.get("selected"))
	_refresh_labels()
	status_label.text = "Updated " + category.replace("_", " ")
