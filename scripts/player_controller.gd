extends CharacterBody3D
## Desktop prototype controls plus a camera ray interaction path.
## Replace the desktop camera rig with an XROrigin3D / XRCamera3D for Quest.

@export var move_speed: float = 3.0
@export var look_sensitivity: float = 0.002
@export var interaction_distance: float = 3.0
@onready var head: Node3D = $Head

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * look_sensitivity)
		head.rotate_x(-event.relative.y * look_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-75), deg_to_rad(75))
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("interact"):
		_interact_forward()
	if event.is_action_pressed("eat_food"):
		get_tree().get_first_node_in_group("game_manager").consume_food()

func _interact_forward() -> void:
	var camera := head.get_node_or_null("Camera3D") as Camera3D
	if camera == null:
		return
	var start := camera.global_position
	var finish := start + (-camera.global_transform.basis.z * interaction_distance)
	var query := PhysicsRayQueryParameters3D.create(start, finish)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self]
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return
	var target: Node = hit.collider
	if target.has_method("interact"):
		get_tree().get_first_node_in_group("game_manager").interact_with(target)

func _physics_process(delta: float) -> void:
	var input_2d := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_2d.x, 0, input_2d.y)).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	else:
		velocity.y = 0.0
	move_and_slide()
