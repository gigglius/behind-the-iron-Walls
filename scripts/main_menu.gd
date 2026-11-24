extends Control
## Cinematic, sepia-toned front end inspired by historical Berlin Wall imagery.

const GAME_SCENE := "res://scenes/Main.tscn"
var notice_label: Label
var subpanel: VBoxContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_menu()
	queue_redraw()

func _draw() -> void:
	var w := size.x
	var h := size.y
	# Warm, overcast sky.
	for i in range(24):
		var t := float(i) / 24.0
		var shade := Color(0.72, 0.67, 0.58).lerp(Color(0.48, 0.45, 0.40), t)
		draw_rect(Rect2(0, h * t, w, h / 24.0 + 2), shade)
	# Distant city silhouettes softened by haze.
	_draw_building(w * 0.37, h * 0.39, w * 0.055, h * 0.25, Color(0.48, 0.46, 0.41, 0.38))
	_draw_building(w * 0.49, h * 0.43, w * 0.075, h * 0.21, Color(0.43, 0.42, 0.38, 0.34))
	_draw_building(w * 0.80, h * 0.40, w * 0.10, h * 0.24, Color(0.43, 0.41, 0.37, 0.42))
	# Distant television tower.
	draw_rect(Rect2(w * 0.523, h * 0.20, w * 0.004, h * 0.31), Color(0.36, 0.34, 0.30, 0.55))
	draw_circle(Vector2(w * 0.525, h * 0.27), h * 0.027, Color(0.39, 0.36, 0.31, 0.62))
	draw_circle(Vector2(w * 0.525, h * 0.27), h * 0.018, Color(0.69, 0.64, 0.55, 0.65))
	# Watchtower on the right.
	draw_rect(Rect2(w * 0.765, h * 0.19, w * 0.026, h * 0.46), Color(0.43, 0.40, 0.34))
	draw_rect(Rect2(w * 0.744, h * 0.13, w * 0.069, h * 0.12), Color(0.30, 0.29, 0.26))
	draw_colored_polygon(PackedVector2Array([Vector2(w * 0.735, h * 0.13), Vector2(w * 0.825, h * 0.13), Vector2(w * 0.811, h * 0.09), Vector2(w * 0.75, h * 0.09)]), Color(0.25, 0.24, 0.22))
	draw_rect(Rect2(w * 0.758, h * 0.155, w * 0.012, h * 0.022), Color(0.75, 0.69, 0.57))
	draw_rect(Rect2(w * 0.786, h * 0.155, w * 0.012, h * 0.022), Color(0.75, 0.69, 0.57))
	# Elevated rail/bridge silhouette entering from the left.
	draw_colored_polygon(PackedVector2Array([Vector2(0, h * 0.04), Vector2(w * 0.12, h * 0.08), Vector2(w * 0.20, h * 0.31), Vector2(w * 0.18, h * 0.34), Vector2(w * 0.10, h * 0.14), Vector2(0, h * 0.12)]), Color(0.20, 0.19, 0.17, 0.92))
	for i in range(8):
		var x := w * (0.035 + float(i) * 0.018)
		draw_line(Vector2(x, h * 0.12), Vector2(x + w * 0.012, h * 0.29), Color(0.16, 0.15, 0.14, 0.9), 4.0)
	# Fog bands.
	for i in range(8):
		var y := h * (0.34 + float(i) * 0.045)
		draw_rect(Rect2(0, y, w, h * 0.055), Color(0.88, 0.83, 0.73, 0.10))
	# Wall in foreground.
	draw_rect(Rect2(0, h * 0.64, w, h * 0.36), Color(0.48, 0.45, 0.39))
	draw_rect(Rect2(0, h * 0.64, w, h * 0.025), Color(0.66, 0.62, 0.53))
	draw_rect(Rect2(0, h * 0.665, w, h * 0.012), Color(0.28, 0.27, 0.24, 0.8))
	for i in range(22):
		var x := w * (float(i) / 22.0)
		draw_line(Vector2(x, h * 0.68), Vector2(x + w * 0.018, h), Color(0.34, 0.32, 0.28, 0.35), 1.0)
	# Abstract graffiti marks: decorative only.
	for i in range(34):
		var x := w * (0.30 + float(i) * 0.020)
		var y := h * (0.72 + float((i * 7) % 13) * 0.018)
		var c := Color(0.17, 0.19, 0.17, 0.65) if i % 3 == 0 else Color(0.28, 0.22, 0.18, 0.58)
		draw_line(Vector2(x, y), Vector2(x + w * 0.012, y - h * 0.018), c, 3.0)
		draw_line(Vector2(x + w * 0.004, y + h * 0.012), Vector2(x + w * 0.015, y - h * 0.004), c, 2.0)
	# Final atmospheric veil.
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
	notice_label.custom_minimum_size = Vector2(470, 55)
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

func _continue_game() -> void:
	notice_label.text = "No saved game yet. Choose NEW GAME to begin."

func _new_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _load_game() -> void:
	notice_label.text = "There are no save files yet."

func _show_options() -> void:
	notice_label.text = "OPTIONS  •  Audio and graphics settings are not implemented yet."

func _show_credits() -> void:
	notice_label.text = "BEHIND THE IRON WALLS\\nA fictional prison-life exploration game."

func _exit_game() -> void:
	get_tree().quit()
