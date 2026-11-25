extends Control
## Main menu with OpenXR startup, controller-ray UI input, and safe scene loading.

const GAME_SCENE := "res://scenes/Main.tscn"
const XR_MENU_PLANE_DISTANCE := 2.0

var notice_label: Label
var menu_buttons: Array[Button] = []
var loading_overlay: ColorRect
var loading_label: Label
var loading_bar: ProgressBar

var xr_interface: XRInterface
var xr_origin: XROrigin3D
var xr_camera: XRCamera3D
var left_controller: XRController3D
var right_controller: XRController3D
var pointer: ColorRect
var previous_trigger_state := false
var xr_ready := false
var loading_started := false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_menu()
	_build_loading_overlay()
	_build_xr_rig()
	queue_redraw()
	call_deferred("_initialize_openxr")

func _process(_delta: float) -> void:
	if xr_ready:
		_update_controller_pointer()

func _draw() -> void:
	var w := size.x
	var h := size.y
	for i in range(24):
		var t := float(i) / 24.0
		var shade := Color(0.72, 0.67, 0.58).lerp(Color(0.48, 0.45, 0.40), t)
		draw_rect(Rect2(0, h * t, w, h / 24.0 + 2), shade)
	_draw_building(w * 0.37, h * 0.39, w * 0.055, h * 0.25, Color(0.48, 0.46, 0.41, 0.38))
	_draw_building(w * 0.49, h * 0.43, w * 0.075, h * 0.21, Color(0.43, 0.42, 0.38, 0.34))
	_draw_building(w * 0.80, h * 0.40, w * 0.10, h * 0.24, Color(0.43, 0.41, 0.37, 0.42))
	draw_rect(Rect2(w * 0.523, h * 0.20, w * 0.004, h * 0.31), Color(0.36, 0.34, 0.30, 0.55))
	draw_circle(Vector2(w * 0.525, h * 0.27), h * 0.027, Color(0.39, 0.36, 0.31, 0.62))
	draw_circle(Vector2(w * 0.525, h * 0.27), h * 0.018, Color(0.69, 0.64, 0.55, 0.65))
	draw_rect(Rect2(w * 0.765, h * 0.19, w * 0.026, h * 0.46), Color(0.43, 0.40, 0.34))
	draw_rect(Rect2(w * 0.744, h * 0.13, w * 0.069, h * 0.12), Color(0.30, 0.29, 0.26))
	draw_colored_polygon(PackedVector2Array([Vector2(w * 0.735, h * 0.13), Vector2(w * 0.825, h * 0.13), Vector2(w * 0.811, h * 0.09), Vector2(w * 0.75, h * 0.09)]), Color(0.25, 0.24, 0.22))
	draw_rect(Rect2(w * 0.758, h * 0.155, w * 0.012, h * 0.022), Color(0.75, 0.69, 0.57))
	draw_rect(Rect2(w * 0.786, h * 0.155, w * 0.012, h * 0.022), Color(0.75, 0.69, 0.57))
	draw_colored_polygon(PackedVector2Array([Vector2(0, h * 0.04), Vector2(w * 0.12, h * 0.08), Vector2(w * 0.20, h * 0.31), Vector2(w * 0.18, h * 0.34), Vector2(w * 0.10, h * 0.14), Vector2(0, h * 0.12)]), Color(0.20, 0.19, 0.17, 0.92))
	for i in range(8):
		var x := w * (0.035 + float(i) * 0.018)
		draw_line(Vector2(x, h * 0.12), Vector2(x + w * 0.012, h * 0.29), Color(0.16, 0.15, 0.14, 0.9), 4.0)
	for i in range(8):
		var y := h * (0.34 + float(i) * 0.045)
		draw_rect(Rect2(0, y, w, h * 0.055), Color(0.88, 0.83, 0.73, 0.10))
	draw_rect(Rect2(0, h * 0.64, w, h * 0.36), Color(0.48, 0.45, 0.39))
	draw_rect(Rect2(0, h * 0.64, w, h * 0.025), Color(0.66, 0.62, 0.53))
	draw_rect(Rect2(0, h * 0.665, w, h * 0.012), Color(0.28, 0.27, 0.24, 0.8))
	for i in range(22):
		var x := w * (float(i) / 22.0)
		draw_line(Vector2(x, h * 0.68), Vector2(x + w * 0.018, h), Color(0.34, 0.32, 0.28, 0.35), 1.0)
	for i in range(34):
		var x := w * (0.30 + float(i) * 0.020)
		var y := h * (0.72 + float((i * 7) % 13) * 0.018)
		var c := Color(0.17, 0.19, 0.17, 0.65) if i % 3 == 0 else Color(0.28, 0.22, 0.18, 0.58)
		draw_line(Vector2(x, y), Vector2(x + w * 0.012, y - h * 0.018), c, 3.0)
		draw_line(Vector2(x + w * 0.004, y + h * 0.012), Vector2(x + w * 0.015, y - h * 0.004), c, 2.0)
	draw_rect(Rect2(Vector2.ZERO, size), Color(0.86, 0.80, 0.69, 0.17))

func _draw_building(x: float, y: float, bw: float, bh: float, tint: Color) -> void:
	draw_rect(Rect2(x, y, bw, bh), tint)
	for row in range(3):
		for col in range(3):
			draw_rect(Rect2(x + bw * (0.15 + col * 0.27), y + bh * (0.16 + row * 0.23), bw * 0.08, bh * 0.08), Color(0.75, 0.70, 0.60, 0.35))

func _build_menu() -> void:
	var title_small := _label("the", 22, Color(0.97, 0.94, 0.86))
	title_small.position = Vector2(220, 35)
	add_child(title_small)
	var title := _label("BEHIND THE\nIRON WALLS", 48, Color(1.0, 0.97, 0.89))
	title.position = Vector2(218, 55)
	title.add_theme_font_size_override("font_size", 48)
	add_child(title)
	var subtitle := _label("1960", 19, Color(0.97, 0.94, 0.86))
	subtitle.position = Vector2(222, 157)
	add_child(subtitle)

	var menu := VBoxContainer.new()
	menu.position = Vector2(220, 218)
	menu.custom_minimum_size = Vector2(280, 0)
	menu.add_theme_constant_override("separation", 1)
	add_child(menu)
	_add_menu_item(menu, "CONTINUE", _continue_game)
	_add_menu_item(menu, "NEW GAME", _new_game)
	_add_menu_item(menu, "LOAD GAME", _load_game)
	_add_menu_item(menu, "OPTIONS", _show_options)
	_add_menu_item(menu, "CREDITS", _show_credits)
	_add_menu_item(menu, "EXIT", _exit_game)

	notice_label = _label("", 16, Color(1.0, 0.92, 0.78))
	notice_label.position = Vector2(220, 500)
	notice_label.custom_minimum_size = Vector2(560, 70)
	add_child(notice_label)

func _label(value: String, font_size: int, tint: Color) -> Label:
	var label := Label.new()
	label.text = value
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", tint)
	label.add_theme_color_override("font_shadow_color", Color(0.15, 0.13, 0.11, 0.55))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	return label

func _add_menu_item(parent: VBoxContainer, caption: String, action: Callable) -> void:
	var button := Button.new()
	button.text = caption
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.custom_minimum_size = Vector2(270, 39)
	button.focus_mode = Control.FOCUS_ALL
	button.add_theme_font_size_override("font_size", 25)
	button.add_theme_color_override("font_color", Color(0.98, 0.95, 0.87))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.83, 0.55))
	button.add_theme_color_override("font_pressed_color", Color(0.86, 0.77, 0.63))
	var clear := StyleBoxEmpty.new()
	button.add_theme_stylebox_override("normal", clear)
	button.add_theme_stylebox_override("hover", clear)
	button.add_theme_stylebox_override("pressed", clear)
	button.add_theme_stylebox_override("focus", clear)
	button.pressed.connect(action)
	parent.add_child(button)
	menu_buttons.append(button)

func _build_loading_overlay() -> void:
	loading_overlay = ColorRect.new()
	loading_overlay.color = Color(0.035, 0.03, 0.025, 0.94)
	loading_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	loading_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	loading_overlay.visible = false
	loading_overlay.z_index = 100
	add_child(loading_overlay)

	loading_label = Label.new()
	loading_label.text = "ENTERING THE PRISON..."
	loading_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	loading_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	loading_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	loading_label.position = Vector2(-260, -45)
	loading_label.size = Vector2(520, 55)
	loading_label.add_theme_font_size_override("font_size", 30)
	loading_label.add_theme_color_override("font_color", Color(0.94, 0.88, 0.75))
	loading_overlay.add_child(loading_label)

	loading_bar = ProgressBar.new()
	loading_bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	loading_bar.position = Vector2(-220, 25)
	loading_bar.size = Vector2(440, 18)
	loading_bar.show_percentage = false
	loading_overlay.add_child(loading_bar)

func _build_xr_rig() -> void:
	xr_origin = XROrigin3D.new()
	xr_origin.name = "MenuXROrigin"
	add_child(xr_origin)

	xr_camera = XRCamera3D.new()
	xr_camera.name = "MenuXRCamera"
	xr_camera.current = false
	xr_origin.add_child(xr_camera)

	left_controller = XRController3D.new()
	left_controller.name = "MenuLeftController"
	left_controller.tracker = &"left_hand"
	left_controller.pose = &"aim"
	xr_origin.add_child(left_controller)

	right_controller = XRController3D.new()
	right_controller.name = "MenuRightController"
	right_controller.tracker = &"right_hand"
	right_controller.pose = &"aim"
	xr_origin.add_child(right_controller)

	pointer = ColorRect.new()
	pointer.name = "VRPointer"
	pointer.color = Color(1.0, 0.82, 0.34, 0.95)
	pointer.size = Vector2(18, 18)
	pointer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pointer.visible = false
	pointer.z_index = 90
	add_child(pointer)

func _initialize_openxr() -> void:
	await get_tree().process_frame
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface == null:
		_set_xr_notice("OpenXR interface not found. Check the Android export includes the OpenXR plugin.")
		return
	if not xr_interface.is_initialized():
		if not xr_interface.initialize():
			_set_xr_notice("OpenXR failed to initialize. Check Quest Link/runtime, OpenXR Android export settings, and the action map.")
			push_error("Behind the Iron Walls: OpenXR initialization failed.")
			return
	get_viewport().use_xr = true
	xr_camera.current = true
	xr_ready = true
	_set_xr_notice("VR ready. Point either controller at a menu option and press its trigger.")
	print("Behind the Iron Walls: OpenXR initialized in main menu.")

func _set_xr_notice(message: String) -> void:
	if notice_label != null:
		notice_label.text = message

func _update_controller_pointer() -> void:
	var screen_position := _controller_ray_to_screen(right_controller)
	if screen_position == Vector2.INF:
		screen_position = _controller_ray_to_screen(left_controller)
		if screen_position != Vector2.INF:
			_handle_controller_trigger(left_controller, screen_position)
	else:
		_handle_controller_trigger(right_controller, screen_position)

	if screen_position == Vector2.INF:
		pointer.visible = false
		previous_trigger_state = false
		return

	pointer.visible = true
	pointer.position = screen_position - pointer.size * 0.5
	var motion := InputEventMouseMotion.new()
	motion.position = screen_position
	motion.global_position = screen_position
	Input.parse_input_event(motion)
	var viewport_rect := get_viewport_rect()
	if screen_position.x < 0.0 or screen_position.y < 0.0 or screen_position.x > viewport_rect.size.x or screen_position.y > viewport_rect.size.y:
		pointer.visible = false

func _controller_ray_to_screen(controller: XRController3D) -> Vector2:
	if controller == null or not controller.visible:
		return Vector2.INF
	var ray_origin := controller.global_position
	var ray_direction := -controller.global_transform.basis.z.normalized()
	var camera_forward := -xr_camera.global_transform.basis.z.normalized()
	var plane_center := xr_camera.global_position + camera_forward * XR_MENU_PLANE_DISTANCE
	var denominator := ray_direction.dot(camera_forward)
	if denominator <= 0.001:
		return Vector2.INF
	var distance := (plane_center - ray_origin).dot(camera_forward) / denominator
	if distance <= 0.0:
		return Vector2.INF
	var hit_point := ray_origin + ray_direction * distance
	return xr_camera.unproject_position(hit_point)

func _handle_controller_trigger(controller: XRController3D, screen_position: Vector2) -> void:
	var pressed := controller.is_button_pressed("trigger_click")
	if pressed and not previous_trigger_state:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = true
		event.position = screen_position
		event.global_position = screen_position
		Input.parse_input_event(event)
	elif not pressed and previous_trigger_state:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = false
		event.position = screen_position
		event.global_position = screen_position
		Input.parse_input_event(event)
	previous_trigger_state = pressed

func _continue_game() -> void:
	notice_label.text = "No saved game yet. Choose NEW GAME to begin."

func _new_game() -> void:
	if loading_started:
		return
	loading_started = true
	for button in menu_buttons:
		button.disabled = true
	loading_overlay.visible = true
	loading_bar.value = 0.0
	loading_label.text = "ENTERING THE PRISON..."
	var fade := create_tween()
	loading_overlay.modulate.a = 0.0
	fade.tween_property(loading_overlay, "modulate:a", 1.0, 0.25)
	await fade.finished

	var request_error := ResourceLoader.load_threaded_request(GAME_SCENE, "PackedScene")
	if request_error != OK:
		_show_load_error("Could not start loading the prison scene. Error code: %s" % error_string(request_error))
		return

	var progress: Array = []
	var status := ResourceLoader.THREAD_LOAD_IN_PROGRESS
	while status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
		status = ResourceLoader.load_threaded_get_status(GAME_SCENE, progress)
		if progress.size() > 0:
			loading_bar.value = float(progress[0]) * 100.0

	if status != ResourceLoader.THREAD_LOAD_LOADED:
		_show_load_error("Godot could not load %s. Check that the scene and its referenced assets exist." % GAME_SCENE)
		return

	var packed_scene := ResourceLoader.load_threaded_get(GAME_SCENE) as PackedScene
	if packed_scene == null:
		_show_load_error("The prison scene loaded as an invalid resource. Expected a PackedScene.")
		return

	loading_label.text = "STARTING THE PRISON..."
	loading_bar.value = 100.0
	await get_tree().process_frame
	var change_error := get_tree().change_scene_to_packed(packed_scene)
	if change_error != OK:
		_show_load_error("The prison scene loaded, but Godot could not start it. Error code: %s" % error_string(change_error))

func _show_load_error(message: String) -> void:
	push_error("Behind the Iron Walls: " + message)
	loading_overlay.visible = false
	loading_started = false
	for button in menu_buttons:
		button.disabled = false
	notice_label.text = "NEW GAME ERROR: " + message

func _load_game() -> void:
	notice_label.text = "There are no save files yet."

func _show_options() -> void:
	notice_label.text = "OPTIONS  •  Audio and graphics settings are not implemented yet."

func _show_credits() -> void:
	notice_label.text = "BEHIND THE IRON WALLS\nA fictional prison-life exploration game."

func _exit_game() -> void:
	get_tree().quit()
