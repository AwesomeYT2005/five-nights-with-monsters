extends Node2D

@onready var cam_tree: AnimatedSprite2D = $CameraTree
@onready var floor_1_buttons: Control = $Floor1Buttons
@onready var floor_2_buttons: Control = $Floor2Buttons
@onready var terrain: AnimatedSprite2D = $Terrain
var game_ready = false

#region Doorman Dependencies
@onready var doorman: Sprite2D = $Terrain/Enemies/Doorman/Doorman
@onready var d_s_timer: Timer = $Terrain/EnemyTimers/Doorman/SpawnTimer
@onready var d_knock: AudioStreamPlayer2D = $Terrain/Enemies/Doorman/Knock
@onready var d_k_timer: Timer = $Terrain/EnemyTimers/Doorman/KnockTimer
@onready var d_footsteps: AudioStreamPlayer2D = $Terrain/Enemies/Doorman/Footsteps
var doorman_spawned = false
var doorman_knocked: int = 0
const DOORMAN_SPAWN_MIN: int = 2 #default = 20
const DOORMAN_SPAWN_MAX: int = 4 #default = 45
const DOORMAN_KNOCK_MIN: int = 2 #default = 2
const DOORMAN_KNOCK_MAX: int = 5 #default = 5
#endregion

#region Chirrup Dependencies
var chirrup_pos_x 
var chirrup_pos_y
@onready var chirrup: AnimatableBody2D = $Terrain/Enemies/Chirrup/Chirrup
@onready var c_s_timer: Timer = $Terrain/EnemyTimers/Chirrup/SpawnTimer
@onready var c_stop_timer: Timer = $Terrain/EnemyTimers/Chirrup/StoppingTimer
@onready var c_laugh: AudioStreamPlayer2D = $Terrain/Enemies/Chirrup/Laugh
@onready var window_area: Area2D = $WindowArea
var chirrup_stage: int = 0
const CHIRRUP_SPAWN_MIN: int = 10
const CHIRRUP_SPAWN_MAX: int = 20
#endregion

#region Corruption dependencies
@onready var corruption: Node2D = $Terrain/Enemies/Corruption
@onready var corruption_indicator: AnimatedSprite2D = $CorruptionIndicator
@onready var beep: AudioStreamPlayer2D = $CorruptionIndicator/Beep
@onready var woosh: AudioStreamPlayer2D = $Terrain/Enemies/Corruption/Woosh
var corruption_scene = preload("res://scenes/enemies/corruption.tscn")
var corruption_instance
var corruption_total: int = 0
#endregion

#region Custom signals
signal player_dead
#endregion

func _ready() -> void:

	#Doorman spawning timer
	d_s_timer.wait_time = randi_range(DOORMAN_SPAWN_MIN,DOORMAN_SPAWN_MAX)
	d_s_timer.start()

	#Chirrup spawning timer
	c_s_timer.wait_time = randi_range(CHIRRUP_SPAWN_MIN,CHIRRUP_SPAWN_MAX)
	c_s_timer.start()

	#Get Chirrup's starting position
	chirrup_pos_y = chirrup.position.y
	
	#Game is ready
	game_ready = true

func _process(_delta: float) -> void:

	#Doorman visible on monitor check
	if terrain.animation == "corridor" and doorman_spawned:
		doorman.visible = true
	else:
		doorman.visible = false
	
	#Doorman footsteps getting quieter
	if d_footsteps.playing:
		d_footsteps.volume_db -= 0.02
	else:
		d_footsteps.volume_db = 10


	#Camera Corruption Indicator
	corruption_indicator.frame = corruption_total
	
	#Corruption death
	if corruption_total == 10:
		player_dead.emit("The Corruption")

func _physics_process(delta: float) -> void:

	#Chirrup behaviour
	if chirrup_stage == 0 or !c_stop_timer.is_stopped():
		pass
	elif chirrup_stage == 1 and chirrup.position.y > -370 and c_stop_timer.is_stopped():
		chirrup.position.y -= 40 * delta
	elif chirrup_stage == 2:
		window_area.monitoring = false
		if chirrup.position.y < chirrup_pos_y:
			chirrup.position.y += 80 * delta
		else:
			chirrup_stage = 0
			chirrup.position.y = chirrup_pos_y
			c_s_timer.wait_time = randi_range(CHIRRUP_SPAWN_MIN,CHIRRUP_SPAWN_MAX)
			c_s_timer.start()
	else:
		player_dead.emit("Chirrup")

#region Functions
func randb(boolean):
	randomize()
	var val = randi_range(0,1)
	if val == 1:
		boolean = true
	elif val == 0:
		boolean = false
	return boolean
#endregion

#region Camera Locations
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
	terrain.animation = "diningroom"

func _on_front_hall_pressed() -> void:
	terrain.animation = "fronthall"

func _on_kitchen_pressed() -> void:
	terrain.animation = "kitchen"

func _on_bedroom_pressed() -> void:
	terrain.animation = "bedroom"

func _on_back_hall_pressed() -> void:
	terrain.animation = "backhall"

func _on_living_room_pressed() -> void:
	terrain.animation = "livingroom"
#endregion

#region Doorman Signals
func _on_doorman_timer_timeout() -> void:
	doorman_spawned = true
	d_knock.play(0.0)

func _on_knock_timer_timeout() -> void:
	d_knock.play(0.0)

func _on_knock_finished() -> void:
	doorman_knocked += 1
	d_knock.volume_db = doorman_knocked * 5.0
	if doorman_knocked < 3:
		d_k_timer.wait_time = randi_range(DOORMAN_KNOCK_MIN,DOORMAN_KNOCK_MAX)
		d_k_timer.start()
	var cam = owner.get_viewport().get_camera_2d().name
	if doorman_knocked == 3 and cam != "Wardrobe":
		player_dead.emit("The Doorman")
	if doorman_knocked == 3 and cam == "Wardrobe":
		doorman_spawned = false
		doorman_knocked = 0
		d_footsteps.play(0.0)
		d_knock.volume_db = 0
		d_s_timer.wait_time = randi_range(DOORMAN_SPAWN_MIN,DOORMAN_SPAWN_MAX)
		d_s_timer.start()
#endregion

#region Chirrup Signals
########################################

# CHIRRUP

########################################

func _on_chirrup_timer_timeout() -> void:
	chirrup_stage = 1
	c_laugh.play()
	window_area.monitoring = true

func _on_window_area_mouse_entered() -> void:
	c_stop_timer.start()

func _on_window_area_mouse_exited() -> void:
	c_stop_timer.stop()

func _on_stopping_timer_timeout() -> void:
	chirrup_stage = 2
#endregion

#region Corruption Signals
func _on_spawn_timer_timeout() -> void:
	var chosen_room
	var f: bool
	for i in range(randi_range(0,3)):
		f = randi_range(0,1)
	var rooms: Array = []
	if f ==  true:
		var rooms_temp = floor_1_buttons.get_children()
		rooms_temp.append_array(floor_2_buttons.get_children())
		for i in rooms_temp:
			rooms.append(i.name)
		chosen_room = rooms.pick_random()
		if chosen_room == "Floor1" or chosen_room == "Floor2":
			pass
		else:
			corruption_instance = corruption_scene.instantiate()
			corruption.add_child(corruption_instance)
			corruption_instance.position = Vector2i(randi_range(-500,500),randi_range(-280,280))
			var cor_name = corruption_instance.get_node("NAME")
			cor_name.name = chosen_room
			corruption_instance.tree_exiting.connect(_on_corruption_tree_exiting)
			corruption_total += 1
			beep.play(0.0)

#Corruption viewing camera check
func _on_terrain_animation_changed() -> void:
	if game_ready == true:
		for i in corruption.get_children():
			if i.name == "Woosh":
				pass
			elif i.get_child(1).name.to_lower() == terrain.animation:
				i.visible = true
			else:
				i.visible = false

func _on_corruption_tree_exiting() -> void:
	corruption_total -= 1
	woosh.play()

#endregion
