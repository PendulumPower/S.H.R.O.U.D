extends Control

@export_file("*.tscn") var game_scene_path: String = "res://TestScene.tcsn"

@onready var play_button: Button = $Margins/ButtonsList/PlayButton
@onready var settings_button: Button = $Margins/ButtonsList/SettingsButton
@onready var quit_button: Button = $Margins/ButtonsList/QuitButton
@onready var host_button: Button = $Margins/ButtonsList/HostButton
@onready var join_button: Button = $Margins/ButtonsList/JoinButton
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	play_button.pressed.connect(_on_play_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://TestScene.tscn")

func _on_host_pressed() -> void:
	print("Multiplayer not yet implemented")	

func _on_join_pressed() -> void:
	print("Multiplayer not yet implemented")	

func _on_settings_pressed() -> void:
	print("Settings not yet implemented")	

func _on_quit_pressed() -> void:
	get_tree().quit()
