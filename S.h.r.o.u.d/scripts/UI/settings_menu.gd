extends CanvasLayer

signal closed

@onready var menu_root: Control = $Control
@onready var back_button: Button = $Control/MarginContainer/VBoxContainer/BackButton

var is_in_game_overlay: bool = false

func _ready() -> void:
	hide()
	back_button.pressed.connect(_on_back_pressed)

func open_menu(in_game: bool = false) -> void:
	is_in_game_overlay = in_game
	show()

func _on_back_pressed() -> void:
	hide()
	
	if is_in_game_overlay:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	closed.emit()
