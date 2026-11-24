extends Control
## Front-end menu for 1960: Behind the Iron Walls.

const GAME_SCENE := "res://scenes/Main.tscn"

var controls_panel: PanelContainer

func _ready() -> void:
	_build_menu()

func _build_menu() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.065, 0.065, 1.0)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	var stripe := ColorRect.new()
	stripe.color = Color(0.42, 0.30, 0.19, 1.0)
	stripe.anchor_left = 0.0
	stripe.anchor_right = 1.0
	stripe.offset_top = 0
	stripe.offset_bottom = 7
	add_child(stripe)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 0)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.10, 0.115, 0.11, 0.97)
	style.border_color = Color(0.43, 0.34, 0.24, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(5)
	style.content_margin_left = 42
	style.content_margin_right = 42
	style.content_margin_top = 34
	style.content_margin_bottom = 34
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	panel.add_child(column)

	var eyebrow := Label.new()
	eyebrow.text = "A FICTIONAL VR EXPERIENCE"
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	eyebrow.add_theme_color_override("font_color", Color(0.72, 0.62, 0.46))
	eyebrow.add_theme_font_size_override("font_size", 15)
	column.add_child(eyebrow)

	var title := Label.new()
	title.text = "BEHIND THE\nIRON WALLS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(0.91, 0.88, 0.79))
	title.add_theme_font_size_override("font_size", 42)
	column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "1960  •  LIFE INSIDE THE WALLS"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_color_override("font_color", Color(0.68, 0.68, 0.62))
	subtitle.add_theme_font_size_override("font_size", 16)
	column.add_child(subtitle)

	var rule := HSeparator.new()
	column.add_child(rule)

	_add_menu_button(column, "START NEW SHIFT", _start_game, true)
	_add_menu_button(column, "CONTROLS & HELP", _toggle_controls)
	_add_menu_button(column, "QUIT GAME", _quit_game)

	controls_panel = PanelContainer.new()
	controls_panel.visible = false
	var help_style := StyleBoxFlat.new()
	help_style.bg_color = Color(0.075, 0.085, 0.08, 1.0)
	help_style.border_color = Color(0.35, 0.32, 0.26, 1.0)
	help_style.set_border_width_all(1)
	help_style.content_margin_left = 16
	help_style.content_margin_right = 16
	help_style.content_margin_top = 12
	help_style.content_margin_bottom = 12
	controls_panel.add_theme_stylebox_override("panel", help_style)
	column.add_child(controls_panel)

	var help_text := Label.new()
	help_text.text = "DESKTOP\nWASD — Move     Mouse — Look\nE — Interact     F — Eat / collect food\nC — Customize character     N — Next workday\n\nVR\nQuest 3 OpenXR support is in development.\nSome interactions still use desktop controls."
	help_text.add_theme_color_override("font_color", Color(0.82, 0.82, 0.76))
	help_text.add_theme_font_size_override("font_size", 15)
	controls_panel.add_child(help_text)

	var footer := Label.new()
	footer.text = "EXPLORE  •  WORK  •  MEET THE PEOPLE"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	footer.add_theme_color_override("font_color", Color(0.52, 0.54, 0.50))
	footer.add_theme_font_size_override("font_size", 12)
	column.add_child(footer)

func _add_menu_button(parent: VBoxContainer, caption: String, callback: Callable, primary := false) -> void:
	var button := Button.new()
	button.text = caption
	button.custom_minimum_size = Vector2(0, 52)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 18)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.32, 0.25, 0.17) if primary else Color(0.15, 0.17, 0.16)
	normal.border_color = Color(0.62, 0.49, 0.31) if primary else Color(0.32, 0.35, 0.32)
	normal.set_border_width_all(1)
	normal.set_corner_radius_all(3)
	button.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = Color(0.42, 0.32, 0.21) if primary else Color(0.22, 0.24, 0.22)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_color_override("font_color", Color(0.94, 0.91, 0.84))
	button.pressed.connect(callback)
	parent.add_child(button)

func _start_game() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _toggle_controls() -> void:
	controls_panel.visible = not controls_panel.visible

func _quit_game() -> void:
	get_tree().quit()
