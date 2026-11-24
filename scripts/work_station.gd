extends Area3D
## Reusable job station. A task is recorded only for the matching active job.
@export_enum("kitchen", "laundry", "library", "workshop", "gardener") var job_id: String = "kitchen"
@export var station_name: String = "Work station"
func _ready() -> void:
	var collision := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(1.5, 1.5, 1.5)
	collision.shape = shape
	add_child(collision)
	var visual := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = Vector3(1.2, 1.2, 1.2)
	visual.mesh = mesh
	add_child(visual)
func interact(_actor: Node) -> String:
	var manager := get_tree().get_first_node_in_group("game_manager")
	if manager == null:
		return "The work system is unavailable."
	return manager.attempt_work(job_id)
