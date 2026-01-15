extends Node2D

@onready var cam_tree: AnimatedSprite2D = $CameraTree
@onready var floor_1_buttons: Control = $Floor1Buttons
@onready var floor_2_buttons: Control = $Floor2Buttons
@onready var terrain: AnimatedSprite2D = $Terrain
@onready var doorman: Sprite2D = $Terrain/Enemies/Doorman/Doorman
@onready var d_s_timer: Timer = $Terrain/EnemyTimers/Doorman/SpawnTimer
@onready var d_knock: AudioStreamPlayer2D = $Terrain/Enemies/Doorman/Knock
@onready var d_k_timer: Timer = $Terrain/EnemyTimers/Doorman/KnockTimer

var doorman_spawned = false
var doorman_knocked: int = 0

signal player_dead

func _ready() -> void:
	
	#Doorman spawning timer
	
	d_s_timer.wait_time = randi_range(30,60)
	d_s_timer.start()

func _process(_delta: float) -> void:
	if terrain.animation == "corridor" and doorman_spawned:
		doorman.visible = true
	else:
		doorman.visible = false

###################################

# SIGNALS

###################################


# All Camera Locations

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

#Timers 

func _on_doorman_timer_timeout() -> void:
	doorman_spawned = true
	d_knock.play(0.0)

func _on_knock_timer_timeout() -> void:
	d_knock.play(0.0)

#Audio

func _on_knock_finished() -> void:
	doorman_knocked += 1
	d_knock.volume_db = doorman_knocked * 5.0
	if doorman_knocked < 3:
		d_k_timer.wait_time = randi_range(5,8)
		d_k_timer.start()
	var cam = owner.get_viewport().get_camera_2d().name
	if doorman_knocked == 3 and cam != "Wardrobe":
		player_dead.emit("The Doorman")
