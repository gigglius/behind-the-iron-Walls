extends Area3D
## Add this script to an Area3D to create a simple reusable interaction target.

@export var display_name: String = "Interact"
@export_multiline var response_text: String = "There is nothing more to say."

func interact(_actor: Node) -> String:
	return response_text
