extends CharacterBody3D

# SETTINGS
@export_group("References")
@export var player_camera: Node3D

@export_group("Movement Stats")
@export var max_speed: float = 8.0
@export var acceleration: float = 20.0
@export var friction: float = 15.0 # How fast you stop when letting go
@export var turn_speed: float = 8.0 # How fast the robot rotates (higher = snappier)

@onready var camera_handler: Node3D = $CameraHandler


func _ready() -> void:
	RemoteConfig.config_updated.connect(_load_config)
	_load_config()
	
func _load_config() -> void:
	max_speed = RemoteConfig.get_value("player_archive_max_speed")
	acceleration = RemoteConfig.get_value("player_archive_acceleration")
	friction = RemoteConfig.get_value("player_archive_friction")
	turn_speed = RemoteConfig.get_value("player_archive_turn_speed")
			

func _process(delta: float) -> void:
	player_camera.global_position = player_camera.global_position.lerp(camera_handler.global_position, 0.1)
	player_camera.look_at(global_position, Vector3.UP)

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Get Input (World Space)
	# We use raw input vector here. We don't multiply by transform.basis yet
	# because we want the robot to turn towards the input, not strafe relative to itself.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	# 3. Handle Movement (Acceleration/Deceleration)
	if direction:
		# Accelerate towards the target speed in the input direction
		velocity.x = move_toward(velocity.x, direction.x * max_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * max_speed, acceleration * delta)
	else:
		# Apply friction to slow down to 0
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	# 4. Handle Rotation (Face the direction of movement)
	# We only rotate if there is significant input to avoid snapping back to 0 when stopped
	if direction.length() > 0.1:
		# Calculate the angle the input is pointing towards
		var target_angle = atan2(-direction.x, -direction.z)
		
		# Smoothly rotate the robot mesh towards that angle
		rotation.y = lerp_angle(rotation.y, target_angle, turn_speed * delta)

	move_and_slide()
