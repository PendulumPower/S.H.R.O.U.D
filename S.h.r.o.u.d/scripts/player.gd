extends CharacterBody3D


@export var walk_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 2.5
@export var jump_velocity = 10.0
@export var acceleration = 1.0
@export var speed_mult = 10.0
@export_range(0.0, 1.0, 0.025) var friction = 0.9

@export var rotation_speed = 12.5;

@export var mouse_sensitivity = 0.002


@export var gravity = 15

@onready var camera = $SpringArm3D/Camera3D 
@onready var collision_shape = $CollisionShape3D
@onready var animations = $Xenon/AnimationPlayer

var standing_height = 2.0
var crouching_height = 1.0
var camera_normal_y = 1.5


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera_normal_y = camera.position.y
	if collision_shape.shape is CapsuleShape3D:
		standing_height = collision_shape.shape.height
	
		crouching_height = standing_height * 0.5


func _physics_process(delta):	
	# stupid hashtags
	# I prefer //, but anyways
	# Build forward and right matrices for smooth movement
	# var sinY = sin(camera.rotation.x);
	# var forward = Vector3(sin(yaw) * (1.0 - sinY), sinY,  cos(yaw) * (1.0 - sinY));
	# var right   = Vector3(cos(yaw) * (1.0 - sinY), sinY, -sin(yaw) * (1.0 - sinY));
	
	# scratch that, there is an easier way
	var forward = -camera.global_transform.basis.z;
	var right   =  camera.global_transform.basis.x;
	# and yes I like making stuff look nice
	
	forward.y = 0;
	right.y   = 0;
	forward = forward.normalized();
	right   = right.normalized();
	
	var x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"));
	var z = int(Input.is_action_pressed("move_forward")) - int(Input.is_action_pressed("move_backward"));
	var movement = forward * z + right * x
	
	# normalize
	if movement.length_squared() > 0.0:
		velocity += movement.normalized() * acceleration * delta
	else:
		velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
	
	# dont do this kind of code. It is only inline since rust spoiled me with doing let speed = if true {1.256} on many lines
	var speed = crouch_speed * sprint_speed if (Input.is_action_pressed("sprint") && Input.is_action_pressed("crouch")) else sprint_speed if Input.is_action_pressed("sprint") else crouch_speed if Input.is_action_pressed("crouch") else walk_speed;
	
	velocity += movement * delta * speed * speed_mult;
	
	
	# handling jumping/gravity
	if not is_on_floor():
		self.velocity.y -= gravity * delta;
	elif Input.is_action_pressed("jump"):
		self.velocity.y = jump_velocity;
	
	
	self.velocity.x *= friction;
	self.velocity.z *= friction;
	move_and_slide();
	
	
	# rotate to velocity direction
	var velocity_xz = Vector2(self.velocity.x, self.velocity.z);
	if velocity_xz.length_squared() > 0.001:
		var target_angle = atan2(velocity.x, velocity.z);
		self.rotation.y = lerp_angle(rotation.y, target_angle + PI, rotation_speed * delta);
	
	
	# Play relevant animation
	if self.velocity.y < -0.1:
		animations.play("Jump_air RT");
	elif self.velocity.y > 0.1:
		animations.play("Jump_Start RT");
	elif abs(self.velocity.x) + abs(self.velocity.z) > 0.1:
		animations.play("Run_Stealth RT");
	else:
		animations.play("Idle_FoldArms RT");
	


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
