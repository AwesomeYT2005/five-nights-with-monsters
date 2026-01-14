extends Node2D

@onready var player_light: PointLight2D = $PlayerLight
@onready var locations: Node = $Locations

func _process(_delta: float) -> void:
	var cam = get_viewport().get_camera_2d().name
	if cam == "Computer":
		player_light.visible = false
	else:
		player_light.visible = true

##################################

# FUNCTIONS

##################################

##################################

# SIGNALS

##################################

func _on_top_arrow_mouse_entered() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam.name == "Backdoor":
		cam.enabled = false
		locations.get_node("Desk").enabled = true
	if cam.name == "Computer":
		cam.enabled = false
		locations.get_node("Desk").enabled = true

func _on_bottom_arrow_mouse_entered() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam.name == "Desk":
		cam.enabled = false
		locations.get_node("Backdoor").enabled = true

func _on_left_arrow_mouse_entered() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam.name == "Desk":
		cam.enabled = false
		locations.get_node("Window").enabled = true

func _on_right_arrow_mouse_entered() -> void:
	var cam = get_viewport().get_camera_2d()
	if cam.name == "Window":
		cam.enabled = false
		locations.get_node("Desk").enabled = true

func _on_pc_screen_pressed() -> void:
		get_viewport().get_camera_2d().enabled = false
		locations.get_node("Computer").enabled = true
