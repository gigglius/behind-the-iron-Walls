extends Area3D
## Neutral character interaction. Work-office staff use work_office.gd instead.
@export var character_name: String = "Prisoner"
@export_multiline var opening_line: String = "The kitchen has been busy today."
func _ready() -> void:
	var collision := CollisionShape3D.new()
	var shape := SphereShape3D.new()
	shape.radius = 1.0
	collision.shape = shape
	add_child(collision)
func interact(_actor: Node) -> String:
	return "%s: %s" % [character_name, opening_line]
