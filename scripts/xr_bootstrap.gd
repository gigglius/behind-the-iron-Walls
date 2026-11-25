extends Node
## Initializes OpenXR and selects the headset camera, with a desktop fallback.

func _ready() -> void:
	call_deferred("_initialize_xr")

func _initialize_xr() -> void:
	await get_tree().process_frame
	var xr_interface := XRServer.find_interface("OpenXR")
	if xr_interface == null:
		push_warning("OpenXR interface not found. Running with the desktop camera.")
		return

	if not xr_interface.is_initialized():
		if not xr_interface.initialize():
			push_error("OpenXR initialization failed in the game scene. Check the Quest OpenXR runtime, Android export settings, and OpenXR action map.")
			return

	get_viewport().use_xr = true
	var desktop_camera := get_node_or_null("../Player/Head/Camera3D") as Camera3D
	var xr_camera := get_node_or_null("../Player/XROrigin3D/XRCamera3D") as XRCamera3D
	if desktop_camera != null:
		desktop_camera.current = false
	if xr_camera != null:
		xr_camera.current = true
	print("OpenXR initialized. Running in Quest VR mode.")
