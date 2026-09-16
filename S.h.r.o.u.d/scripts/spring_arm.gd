extends SpringArm3D

@export var target: CharacterBody3D
@export var mouse_sensitivity: float = 0.002


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity;
		rotation.x = clamp(rotation.x, -PI * 0.33, PI * 0.2);
		rotation.y -= event.relative.x * mouse_sensitivity;


func _process(delta):
	if target:
		global_position = target.global_position;
	
