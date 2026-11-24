extends Node
## Hybrid prison job system: prisoners may apply for work or receive an assignment.

signal job_changed(job_id: String, job_name: String)
signal task_progress_changed(completed: int, required: int)
signal job_completed(job_id: String, bread_reward: int, credit_reward: int)
signal job_message(message: String)

const JOBS := {
	"kitchen": {"name": "Kitchen Worker", "task": "Complete kitchen duties", "tasks_per_day": 3, "bread": 2, "credits": 5},
	"laundry": {"name": "Laundry Worker", "task": "Sort and deliver laundry", "tasks_per_day": 3, "bread": 1, "credits": 6},
	"library": {"name": "Library Assistant", "task": "Organize library books", "tasks_per_day": 2, "bread": 1, "credits": 7},
	"workshop": {"name": "Workshop Worker", "task": "Finish workshop projects", "tasks_per_day": 2, "bread": 1, "credits": 8},
	"gardener": {"name": "Gardener", "task": "Care for courtyard plants", "tasks_per_day": 3, "bread": 2, "credits": 5}
}

var active_job_id: String = ""
var tasks_completed: int = 0
var work_credits: int = 0
var job_experience: int = 0
var job_rank: String = "Unassigned"
var available_job_ids: Array[String] = ["kitchen", "laundry", "library", "workshop", "gardener"]

func get_job_board() -> Array[Dictionary]:
	var board: Array[Dictionary] = []
	for job_id in available_job_ids:
		if JOBS.has(job_id):
			var entry: Dictionary = JOBS[job_id].duplicate()
			entry["id"] = job_id
			board.append(entry)
	return board

func apply_for_job(job_id: String) -> bool:
	if not JOBS.has(job_id):
		job_message.emit("That job is not available.")
		return false
	_assign_job(job_id, "You applied and were accepted for " + str(JOBS[job_id]["name"]) + ".")
	return true

func receive_automatic_assignment() -> String:
	if active_job_id != "":
		return active_job_id
	var candidates := available_job_ids.duplicate()
	candidates = candidates.filter(func(id: String) -> bool: return JOBS.has(id))
	if candidates.is_empty():
		job_message.emit("There are no jobs available today.")
		return ""
	var chosen_id: String = candidates.pick_random()
	_assign_job(chosen_id, "The work office assigned you: " + str(JOBS[chosen_id]["name"]) + ".")
	return chosen_id

func _assign_job(job_id: String, message: String) -> void:
	active_job_id = job_id
	tasks_completed = 0
	job_changed.emit(job_id, str(JOBS[job_id]["name"]))
	task_progress_changed.emit(0, int(JOBS[job_id]["tasks_per_day"]))
	job_message.emit(message)

func complete_task() -> bool:
	if active_job_id == "" or not JOBS.has(active_job_id):
		job_message.emit("You do not have a job assignment.")
		return false
	var job: Dictionary = JOBS[active_job_id]
	var required := int(job["tasks_per_day"])
	if tasks_completed >= required:
		job_message.emit("You have finished today's work.")
		return false
	tasks_completed += 1
	task_progress_changed.emit(tasks_completed, required)
	if tasks_completed == required:
		var bread := int(job["bread"])
		var credits := int(job["credits"])
		work_credits += credits
		job_experience += 1
		_update_rank()
		job_completed.emit(active_job_id, bread, credits)
		job_message.emit("Shift complete! Earned %d bread portions and %d work credits." % [bread, credits])
	return true

func begin_new_day() -> void:
	tasks_completed = 0
	if active_job_id == "":
		receive_automatic_assignment()
	else:
		task_progress_changed.emit(0, int(JOBS[active_job_id]["tasks_per_day"]))
		job_message.emit("A new workday has started.")

func _update_rank() -> void:
	if job_experience >= 10:
		job_rank = "Trusted"
	elif job_experience >= 5:
		job_rank = "Regular"
	elif job_experience >= 1:
		job_rank = "Beginner"
	else:
		job_rank = "Unassigned"
