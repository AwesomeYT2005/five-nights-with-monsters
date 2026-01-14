extends Node2D

@onready var cam_tree: AnimatedSprite2D = $CameraTree
@onready var floor_1_buttons: Control = $Floor1Buttons
@onready var floor_2_buttons: Control = $Floor2Buttons

func _ready() -> void:
	floor_1_buttons.visible = false

func _on_floor_1_pressed() -> void:
	cam_tree.animation = "floor_1"
	floor_1_buttons.visible = true
	floor_2_buttons.visible = false

func _on_floor_2_pressed() -> void:
	cam_tree.animation = "floor_2"
	floor_1_buttons.visible = false
	floor_2_buttons.visible = true

func _on_front_hall_pressed() -> void:
	pass
