extends Area3D
## Hinged cell door toggled by the regular interact action.
@export var door_pivot_path: NodePath
var is_open := false

func interact(_actor: Node) -> String:
    var pivot := get_node_or_null(door_pivot_path) as Node3D
    if pivot == null:
        return "The cell door cannot move."
    is_open = not is_open
    var target_angle := deg_to_rad(88.0) if is_open else 0.0
    var tween := create_tween()
    tween.tween_property(pivot, "rotation:y", target_angle, 0.35)
    return "Cell door opened." if is_open else "Cell door closed."
