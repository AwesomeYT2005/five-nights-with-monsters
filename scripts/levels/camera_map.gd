extends Node2D

@onready var cam_tree: AnimatedSprite2D = $CameraTree
@onready var floor_1_buttons: Control = $Floor1Buttons
@onready var floor_2_buttons: Control = $Floor2Buttons
@onready var terrain: AnimatedSprite2D = $Terrain

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

func _on_corridor_pressed() -> void:
	terrain.animation = "corridor"

func _on_bathroom_pressed() -> void:
	terrain.animation = "bathroom"

func _on_stash_pressed() -> void:
	terrain.animation = "stash"

func _on_outside_pressed() -> void:
	terrain.animation = "outside"

func _on_landing_pressed() -> void:
	terrain.animation = "landing"

func _on_staircase_pressed() -> void:
	terrain.animation = "staircase"

func _on_dining_room_pressed() -> void:
	terrain.animation = "dining_room"

func _on_front_hall_pressed() -> void:
	terrain.animation = "front_hall"

func _on_kitchen_pressed() -> void:
	terrain.animation = "kitchen"

func _on_bedroom_pressed() -> void:
	terrain.animation = "bedroom"

func _on_back_hall_pressed() -> void:
	terrain.animation = "back_hall"

func _on_living_room_pressed() -> void:
	terrain.animation = "living_room"
