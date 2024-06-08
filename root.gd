class_name Root extends Node3D

var custom_font:Font

@onready var environment:Environment = $WorldEnvironment.environment

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_F:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func on_draw_gizmos():
	var size = 5000
	var sub_divisions = size / 100
	# DebugDraw3D.draw_grid(Vector3.ZERO, Vector3.RIGHT* size, Vector3.BACK * size, Vector2(sub_divisions, sub_divisions), Color.WHITE)
	
	# DebugDraw.draw_grid(Vector3.ZERO, Vector3.UP * size, Vector3.BACK * size, Vector2(sub_divisions, sub_divisions), Color.aquamarine)
	# DebugDraw.draw_grid(Vector3.ZERO, Vector3.RIGHT* size, Vector3.BACK * size, Vector2(sub_divisions, sub_divisions), Color.AQUAMARINE)

var xr_interface: XRInterface

var text_size = 30

func _ready():
	custom_font = load("res://fonts/Hyperspace Bold.otf")
	#DebugDraw2D.config.text_custom_font = custom_font
	#DebugDraw2D.config.text_default_size = text_size
	#DebugDraw2D.config.text_background_color = Color.TRANSPARENT
	#DebugDraw2D.config.text_foreground_color = Color.CHARTREUSE
	xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialised successfully")

		# Turn off v-sync!
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

		# Change our main viewport to output to the HMD
		get_viewport().use_xr = true
		var modes = xr_interface.get_supported_environment_blend_modes()
		if XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ALPHA_BLEND
		elif XRInterface.XR_ENV_BLEND_MODE_ADDITIVE in modes:
			xr_interface.environment_blend_mode = XRInterface.XR_ENV_BLEND_MODE_ADDITIVE
		else:
			print("ARGH!!!!")
			return false
	else:
		print("OpenXR not initialized, please check if your headset is connected")
	get_window().set_current_screen(1)
	
	get_viewport().transparent_bg = true
	environment.background_mode = Environment.BG_CLEAR_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR

	 # get_window().set_current_screen(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.	
