extends CharacterBody3D
## Desktop-friendly movement placeholder. Replace input with XR controller actions
## when the OpenXR player rig is added.

@export var move_speed: float = 3.0
@export var look_sensitivity: float = 0.002
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

func _physics_process(_delta: float) -> void:
	var input_2d := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_2d.x, 0, input_2d.y)).normalized()
	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed
	if not is_on_floor():
		velocity.y -= 18.0 * get_physics_process_delta_time()
	else:
		velocity.y = 0.0
	move_and_slide()
