extends Node

@onready var fade: ColorRect = $BlackScreen
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var win_timer: Timer = $WinTimer
@onready var menu_music: AudioStreamPlayer = $MenuMusic

#region Audio

const DOOR_OPEN_CLOSE = preload("res://assets/sounds/enemies/doorman/door_open_close.mp3")
const WINDOW_SMASH = preload("res://assets/sounds/enemies/chirrup/window-smash.mp3")
const LAUGH_DEATH = preload("res://assets/sounds/enemies/chirrup/laugh-death.mp3")
const TOYS_DYING = preload("res://assets/sounds/enemies/corruption/toys_dying.mp3")
const MONSTER_ROAR = preload("res://assets/sounds/enemies/chirrup/monster-roar.mp3")
const RISING_TENSION = preload("res://assets/sounds/enemies/doorman/rising_tension.mp3")
const DUBSTEP_GROWL = preload("res://assets/sounds/enemies/doorman/dubstep_growl.mp3")
const DOORMAN_LINE = preload("res://assets/sounds/enemies/doorman/DoormanDeathLine.mp3")

#endregion

#region Scenes

var main_menu_scene = preload("res://scenes/menu/main_menu.tscn")
var level_scene = preload("res://scenes/levels/level.tscn")

var main_menu_instance
var level_instance

#endregion

#region Enemy Jumpscares

@onready var jumpscare_timer: Timer = $JumpscareTimer
const chirrup_scare_scene = preload("res://scenes/enemies/chirrup.tscn")
const doorman_scare_scene = preload("res://scenes/enemies/doorman_jumpscare.tscn")
var jumpscare
var jumpscared: bool = false
var jumpscared_by
var d_stage = 0
var d_timer1_started = false
var d_timer2_started = false

#endregion

func _ready() -> void:
	load_main_menu()

func _process(_delta) -> void:
	if death_sound.stream == RISING_TENSION:
		death_sound.volume_db += 0.01
	if menu_music.get_playback_position() > 28.85 and !level_instance:
		menu_music.play()

func _physics_process(delta: float) -> void:
	if jumpscared == true:
		var j = get_node_or_null(jumpscared_by)
		if jumpscared_by == "Chirrup":
			j.scale *= Vector2(delta+1.05,delta+1.05)
			j.position += Vector2(randi_range(-5,5),randi_range(-5,5))
			if j.scale > Vector2(45,45):
				jumpscared = false
				death_sound.stop()
				death_sound.finished.emit()
		elif jumpscared_by == "The Doorman":
			if j.position.x < 638 and d_stage == 0:
				j.position.x += delta*160
			elif j.position.x >= 638 and d_stage == 0:
				d_stage = 1
			elif d_stage == 1 and d_timer1_started == false:
				d_timer1_started = true
				await get_tree().create_timer(2,false,true).timeout
				d_stage = 2
				j.play("smile")
			elif d_stage == 2 and d_timer2_started == false:
				d_timer2_started = true
				await get_tree().create_timer(2,false,true).timeout
				d_stage = 3
				j.play("eye")
			elif d_stage == 4:
				j.scale *= Vector2(delta+1.05,delta+1.05)
				death_sound.volume_db = 20
				if j.scale > Vector2(45,45):
					jumpscared = false
					death_sound.stop()
					death_sound.finished.emit()

#region Functions

func load_main_menu() -> void:
	menu_music.play()
	main_menu_instance = main_menu_scene.instantiate()
	self.add_child(main_menu_instance)
	var play_button = main_menu_instance.get_node_or_null("MarginContainer/VBoxContainer/Play")
	var quit_button = main_menu_instance.get_node_or_null("MarginContainer/VBoxContainer/Quit")
	await fadeanimation("in")
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	await fadeanimation("out")
	level_instance = level_scene.instantiate()
	self.add_child(level_instance)
	level_instance.get_node("PlayerLight").visible = false
	level_instance.process_mode = Node.PROCESS_MODE_DISABLED
	var cam_map = level_instance.get_node_or_null("Locations/Computer/CameraMap")
	cam_map.player_dead.connect(_on_camera_map_player_dead)
	main_menu_instance.queue_free()
	menu_music.stop()
	await fadeanimation("in")
	fade.visible = false
	level_instance.get_node("PlayerLight").visible = true
	level_instance.process_mode = Node.PROCESS_MODE_ALWAYS
	win_timer.wait_time = 360.0 #Default: 360.0
	win_timer.start()

func enemy_jumpscare(enemy) -> void:
	if enemy == "Chirrup":
		jumpscare = chirrup_scare_scene.instantiate()
		self.add_child(jumpscare)
		jumpscare.scale = Vector2(0.25,0.25)
		jumpscare.position = Vector2(643,357)
		jumpscared = true
		death_sound.stream = MONSTER_ROAR
		death_sound.play(0.75)
	elif enemy == "The Doorman":
		jumpscare = doorman_scare_scene.instantiate()
		self.add_child(jumpscare)
		jumpscare.animation_finished.connect(_on_jumpscare_animation_finished)
		jumpscare.name = "The Doorman"
		jumpscare.scale = Vector2(6,6)
		jumpscare.position = Vector2(-252,373)
		jumpscared = true
	else:
		pass

func fadeanimation(type) -> void:
	if type == "in":
		for i in range(100):
			await get_tree().create_timer(0.01).timeout
			fade.modulate.a -= 0.01
	if type == "out":
		for i in range(100):
			await get_tree().create_timer(0.01).timeout
			fade.modulate.a += 0.01
#endregion

#region Signals

func _on_camera_map_player_dead(enemy) -> void:
	win_timer.stop()
	fade.visible = true
	jumpscared_by = enemy
	if enemy == "The Doorman":
		death_sound.stream = DOOR_OPEN_CLOSE
	if enemy == "Chirrup":
		death_sound.stream = WINDOW_SMASH
	if enemy == "The Corruption":
		death_sound.stream = TOYS_DYING
	var killtag = fade.get_node_or_null("Labels/TextureRect2/KillTag")
	killtag.text = enemy
	death_sound.play(0.0)
	jumpscare_timer.start(5)
	level_instance.queue_free()

func _on_death_sound_finished() -> void:
	if death_sound.stream == WINDOW_SMASH:
		pass
	elif death_sound.stream == RISING_TENSION:
		pass
	elif death_sound.stream == DOOR_OPEN_CLOSE:
		await get_tree().create_timer(2.5).timeout
		death_sound.stream = RISING_TENSION
		death_sound.volume_db = -10
		death_sound.play(0.0)
	elif death_sound.stream == MONSTER_ROAR:
		death_sound.stream = LAUGH_DEATH
		death_sound.play(0.0)
		get_node(jumpscared_by).queue_free()
		fade.get_node("Labels").visible = true
	elif death_sound.stream == DUBSTEP_GROWL:
		death_sound.stream = DOORMAN_LINE
		death_sound.play(0.0)
		get_node(jumpscared_by).queue_free()
		fade.get_node("Labels").visible = true
	else:
		load_main_menu()
		fade.visible = false
		fade.get_node("Labels").visible = false

func _on_jumpscare_timer_timeout() -> void:
	enemy_jumpscare(jumpscared_by)

func _on_jumpscare_animation_finished() -> void:
	if jumpscare.animation == "eye":
		await get_tree().create_timer(1).timeout
		death_sound.stream = DUBSTEP_GROWL
		death_sound.play(0)
		d_stage = 4

func _on_win_timer_timeout() -> void:
	level_instance.queue_free()
	fade.modulate.a = 1.0
	fade.visible = true
	fade.get_node("Win").visible = true
	await get_tree().create_timer(5).timeout
	fade.get_node("Win").visible = false
	load_main_menu()

#endregion
