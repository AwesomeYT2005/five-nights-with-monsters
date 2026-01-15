extends Node

var main_menu = preload("res://scenes/menu/main_menu.tscn").instantiate()
var level = preload("res://scenes/levels/level.tscn").instantiate()
func _ready() -> void:
	load_main_menu()

func _on_play_button_pressed() -> void:
	self.add_child(level)
	level.tree_exited.connect(_on_level_tree_exited)
	main_menu.queue_free()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func load_main_menu() -> void:
	self.add_child(main_menu)
	var play_button = main_menu.get_node_or_null("MarginContainer/VBoxContainer/Play")
	var quit_button = main_menu.get_node_or_null("MarginContainer/VBoxContainer/Quit")
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_level_tree_exited() -> void:
	#load_main_menu()
	pass
