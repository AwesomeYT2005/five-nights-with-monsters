extends Node

@onready var fade: ColorRect = $BlackScreen
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

#region Audio

const DOOR_OPEN_CLOSE = preload("res://assets/sounds/enemies/doorman/door_open_close.mp3")
const WINDOW_SMASH = preload("res://assets/sounds/enemies/chirrup/window-smash.mp3")
const LAUGH_DEATH = preload("res://assets/sounds/enemies/chirrup/laugh-death.mp3")
const TOYS_DYING = preload("res://assets/sounds/enemies/corruption/toys_dying.mp3")
const MONSTER_ROAR = preload("res://assets/sounds/enemies/chirrup/monster-roar.mp3")

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
var jumpscare
var jumpscared: bool = false
var jumpscared_by

#endregion

func _ready() -> void:
	load_main_menu()

func _physics_process(delta: float) -> void:
	if jumpscared == true:
		var j = get_node_or_null(jumpscared_by)
		j.scale *= Vector2(delta+1.05,delta+1.05)
		j.position += Vector2(randi_range(-3,3),randi_range(-3,3))
		if j.scale > Vector2(45,45):
			jumpscared = false
			death_sound.stop()
			death_sound.finished.emit()

func _on_play_button_pressed() -> void:
	level_instance = level_scene.instantiate()
	self.add_child(level_instance)
	var cam_map = level_instance.get_node_or_null("Locations/Computer/CameraMap")
	cam_map.player_dead.connect(_on_camera_map_player_dead)
	main_menu_instance.queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func load_main_menu() -> void:
	main_menu_instance = main_menu_scene.instantiate()
	self.add_child(main_menu_instance)
	var play_button = main_menu_instance.get_node_or_null("MarginContainer/VBoxContainer/Play")
	var quit_button = main_menu_instance.get_node_or_null("MarginContainer/VBoxContainer/Quit")
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func enemy_jumpscare(enemy) -> void:
	if enemy == "Chirrup":
		jumpscare = chirrup_scare_scene.instantiate()
		self.add_child(jumpscare)
		jumpscare.scale = Vector2(0.25,0.25)
		jumpscare.position = Vector2(643,357)
		jumpscared = true
		death_sound.stream = MONSTER_ROAR
		death_sound.play(0.75)
	else:
		pass

func _on_camera_map_player_dead(enemy) -> void:
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
	jumpscare_timer.start(randi_range(3,6))
	level_instance.queue_free()

func _on_death_sound_finished() -> void:
	if death_sound.stream == WINDOW_SMASH:
		pass
	elif death_sound.stream == MONSTER_ROAR:
		death_sound.stream = LAUGH_DEATH
		death_sound.play(0.0)
		get_node(jumpscared_by).queue_free()
		fade.get_node("Labels").visible = true
	else:
		load_main_menu()
		fade.visible = false
		fade.get_node("Labels").visible = false

func _on_jumpscare_timer_timeout() -> void:
	enemy_jumpscare(jumpscared_by)
