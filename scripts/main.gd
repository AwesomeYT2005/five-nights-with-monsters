extends Node

@onready var fade: ColorRect = $BlackScreen
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

const DOOR_OPEN_CLOSE = preload("res://assets/sounds/enemies/doorman/door_open_close.mp3")
const WINDOW_SMASH = preload("res://assets/sounds/enemies/chirrup/window-smash.mp3")
const LAUGH_DEATH = preload("res://assets/sounds/enemies/chirrup/laugh-death.mp3")
var main_menu_scene = preload("res://scenes/menu/main_menu.tscn")
var level_scene = preload("res://scenes/levels/level.tscn")

var main_menu_instance
var level_instance

func _ready() -> void:
	load_main_menu()

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

func _on_camera_map_player_dead(enemy) -> void:
	fade.visible = true
	if enemy == "The Doorman":
		death_sound.stream = DOOR_OPEN_CLOSE
	if enemy == "Chirrup":
		death_sound.stream = WINDOW_SMASH
	var killtag = fade.get_node_or_null("TextureRect2/KillTag")
	killtag.text = enemy
	death_sound.play(0.0)
	level_instance.queue_free()

func _on_death_sound_finished() -> void:
	if death_sound.stream == WINDOW_SMASH:
		death_sound.stream = LAUGH_DEATH
		death_sound.play()
	else:
		load_main_menu()
		fade.visible = false
