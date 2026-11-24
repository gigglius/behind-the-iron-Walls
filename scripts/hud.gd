extends CanvasLayer
## Simple desktop HUD and job board. Replace with a world-space VR panel later.
var food_label: Label
var job_label: Label
var task_label: Label
var message_label: Label
var board_label: Label
var board_open := false
var job_ids := ["kitchen", "laundry", "library", "workshop", "gardener"]
func _ready() -> void:
	var panel := PanelContainer.new()
	panel.position = Vector2(16, 16)
	panel.custom_minimum_size = Vector2(390, 170)
	add_child(panel)
	var column := VBoxContainer.new()
	panel.add_child(column)
	food_label = Label.new()
	job_label = Label.new()
	task_label = Label.new()
	message_label = Label.new()
	column.add_child(food_label)
	column.add_child(job_label)
	column.add_child(task_label)
	column.add_child(message_label)
	board_label = Label.new()
	board_label.position = Vector2(16, 205)
	board_label.custom_minimum_size = Vector2(480, 240)
	add_child(board_label)
	board_label.visible = false
	show_message("E: interact   F: eat   N: next workday")
	set_task_progress(0, 0)
func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if board_open:
		var key_to_index := {KEY_1: 0, KEY_2: 1, KEY_3: 2, KEY_4: 3, KEY_5: 4}
		if key_to_index.has(event.keycode):
			var manager := get_tree().get_first_node_in_group("game_manager")
			manager.apply_for_job(job_ids[key_to_index[event.keycode]])
			board_open = false
			board_label.visible = false
			get_viewport().set_input_as_handled()
			return
		if event.keycode == KEY_ESCAPE:
			board_open = false
			board_label.visible = false
			get_viewport().set_input_as_handled()
			return
	if event.keycode == KEY_N:
		get_tree().current_scene.get_node("JobSystem").begin_new_day()
func set_food(portions: int) -> void:
	if food_label != null:
		food_label.text = "Food portions: %d" % portions
func set_job(job_name: String, rank: String, credits: int) -> void:
	if job_label != null:
		job_label.text = "Job: %s | Rank: %s | Credits: %d" % [job_name, rank, credits]
func set_task_progress(completed: int, required: int) -> void:
	if task_label != null:
		task_label.text = "Today's work: %d / %d tasks" % [completed, required]
func show_message(message: String) -> void:
	if message_label != null:
		message_label.text = message
func show_job_board(board: Array[Dictionary], active_job: String) -> void:
	var lines := ["PRISON WORK OFFICE — choose 1–5 to apply:"]
	for i in range(board.size()):
		var job: Dictionary = board[i]
		lines.append("%d. %s — %d tasks | %d bread | %d credits" % [i + 1, job["name"], job["tasks_per_day"], job["bread"], job["credits"]])
	lines.append("Current assignment: " + (active_job if active_job != "" else "None"))
	lines.append("Press ESC to close.")
	board_label.text = "\n".join(lines)
	board_label.visible = true
	board_open = true
