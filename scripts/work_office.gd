extends Area3D
## Work-office NPC opens the job board. Players can apply to any listed job.
@export var staff_name: String = "Work Office Clerk"
func _ready() -> void:
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 1.3
	collision.shape = shape
	add_child(collision)
func interact(_actor: Node) -> String:
	var manager := get_tree().get_first_node_in_group("game_manager")
	if manager != null:
		manager.open_job_board()
	return staff_name + ": The job board is open. Choose a position with keys 1 through 5."
