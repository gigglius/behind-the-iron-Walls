extends Area3D
## Friendly / neutral NPC dialogue stub. Dialogue can later branch by quest state.

@export var character_name: String = "Prisoner"
@export_multiline var opening_line: String = "Keep your head down. The courtyard is watched."

func interact(_actor: Node) -> String:
	return "%s: %s" % [character_name, opening_line]
