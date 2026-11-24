extends Node
## Starts OpenXR when available and switches to the headset camera.

func _ready() -> void:
	call_deferred("_initialize_xr")

func _initialize_xr() -> void:
	var xr_interface := XRServer.find_interface("OpenXR")
	if xr_interface == null:
		push_warning("OpenXR interface not found. Running desktop fallback.")
		return
	if not xr_interface.is_initialized() and not xr_interface.initialize():
		push_warning("OpenXR could not initialize. Check Project Settings > XR > OpenXR.")
		return
	get_viewport().use_xr = true
	var desktop_camera := get_node_or_null("../Player/Head/Camera3D") as Camera3D
	var xr_camera := get_node_or_null("../Player/XROrigin3D/XRCamera3D") as Camera3D
	if desktop_camera != null:
		desktop_camera.current = false
	if xr_camera != null:
		xr_camera.current = true
	print("OpenXR initialized. Running in headset mode.")
