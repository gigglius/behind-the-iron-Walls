extends Node3D
## Coordinates food, jobs, workstations, and the prototype HUD.

@export var starting_food: int = 3
var food_portions: int
var checkpoint_position := Vector3(0, 1, 2)

@onready var food_system: Node = $FoodSystem
@onready var job_system: Node = $JobSystem
@onready var hud: Node = $HUD

func _ready() -> void:
	add_to_group("game_manager")
	food_system.food_changed.connect(_on_food_changed)
	job_system.job_changed.connect(_on_job_changed)
	job_system.task_progress_changed.connect(_on_task_progress_changed)
	job_system.job_completed.connect(_on_job_completed)
	job_system.job_message.connect(_on_job_message)
	job_system.begin_new_day()
	_on_food_changed(food_system.portions)
	_on_job_changed(job_system.active_job_id, _active_job_name())

func _active_job_name() -> String:
	if job_system.active_job_id == "":
		return "Unassigned"
	return str(job_system.JOBS[job_system.active_job_id]["name"])

func interact_with(target: Node) -> void:
	if target != null and target.has_method("interact"):
		var message: String = target.interact(self)
		if message != "":
			hud.show_message(message)

func attempt_work(job_id: String) -> String:
	if job_system.active_job_id == "":
		return "Visit the work office to apply for a job, or wait for an assignment."
	if job_system.active_job_id != job_id:
		return "This station is for a different job. Your current job is " + _active_job_name() + "."
	job_system.complete_task()
	return "Work task recorded: %d tasks completed." % job_system.tasks_completed

func open_job_board() -> void:
	hud.show_job_board(job_system.get_job_board(), job_system.active_job_id)

func apply_for_job(job_id: String) -> void:
	job_system.apply_for_job(job_id)

func consume_food() -> void:
	if not food_system.eat():
		hud.show_message("You need food. Find bread or finish a work shift.")
	else:
		hud.show_message("You ate one portion.")

func return_to_checkpoint(player: Node3D) -> void:
	if is_instance_valid(player):
		player.global_position = checkpoint_position
		player.velocity = Vector3.ZERO

func _on_food_changed(portions: int) -> void:
	hud.set_food(portions)

func _on_job_changed(job_id: String, job_name: String) -> void:
	hud.set_job(job_name, job_system.job_rank, job_system.work_credits)

func _on_task_progress_changed(completed: int, required: int) -> void:
	hud.set_task_progress(completed, required)

func _on_job_completed(_job_id: String, bread_reward: int, _credit_reward: int) -> void:
	food_system.collect(bread_reward)
	hud.set_job(_active_job_name(), job_system.job_rank, job_system.work_credits)

func _on_job_message(message: String) -> void:
	hud.show_message(message)
