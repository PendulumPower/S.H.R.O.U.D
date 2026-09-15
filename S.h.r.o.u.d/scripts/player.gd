extends CharacterBody3D

@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 2.5
@export var jump_velocity = 5
@export var mouse_sensitivity = 0.002

var gravity = 15
var current_speed = walk_speed

@onready var camera = $Camera3D 
@onready var collision_shape = $CollisionShape3D

var standing_height = 2.0
var crouching_height = 1.0
var camera_normal_y = 1.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_normal_y = camera.position.y
	if collision_shape.shape is CapsuleShape3D:
		standing_height = collision_shape.shape.height
		crouching_height = standing_height * 0.5

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	var target_height = standing_height
	var target_camera_y = camera_normal_y

	if Input.is_action_pressed("crouch"):
		current_speed = crouch_speed
		target_height = crouching_height
		target_camera_y = camera_normal_y - (standing_height - crouching_height) / 2.0
	elif Input.is_action_pressed("sprint") and is_on_floor():
		current_speed = sprint_speed
	else:
		current_speed = walk_speed

	if collision_shape.shape is CapsuleShape3D:
		collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, delta * 10.0)
	camera.position.y = lerp(camera.position.y, target_camera_y, delta * 10.0)

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
