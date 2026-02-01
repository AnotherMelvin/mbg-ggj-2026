class_name PathfindingCharacterController
extends CharacterBody3D

@export_group("References")
@export var type: Utils.ENEMY_TYPE
@export var pathways: Array[RobotPath] 

@export_group("Movement Stats")
@export var max_speed: float = 5.0
@export var acceleration: float = 10.0
@export var friction: float = 15.0
@export var turn_speed: float = 5.0
@export var stopping_distance: float = 0.5

# State Variables
var current_path: RobotPath
var _current_path_index: int = 0
var _is_waiting: bool = false 

func _ready() -> void:
	RemoteConfig.config_updated.connect(_load_config)
	_load_config()
	
	if pathways.is_empty():
		set_physics_process(false)
		return
	current_path = pathways[0]

func _load_config() -> void:
	match type:
		Utils.ENEMY_TYPE.ARCHIVE_1:
			max_speed = RemoteConfig.get_value("enemy1_archive_max_speed")
			acceleration = RemoteConfig.get_value("enemy1_archive_acceleration")
			friction = RemoteConfig.get_value("enemy1_archive_friction")
			turn_speed = RemoteConfig.get_value("enemy1_archive_turn_speed")
			stopping_distance = RemoteConfig.get_value("enemy1_archive_stopping_distance")
		Utils.ENEMY_TYPE.ARCHIVE_2:
			max_speed = RemoteConfig.get_value("enemy2_archive_max_speed")
			acceleration = RemoteConfig.get_value("enemy2_archive_acceleration")
			friction = RemoteConfig.get_value("enemy2_archive_friction")
			turn_speed = RemoteConfig.get_value("enemy2_archive_turn_speed")
			stopping_distance = RemoteConfig.get_value("enemy2_archive_stopping_distance")

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	var direction := Vector3.ZERO
	
	# 2. Movement Logic (Only if we are NOT waiting)
	if current_path and not _is_waiting:
		var target_pos = current_path.global_position
		target_pos.y = global_position.y
		
		var distance = global_position.distance_to(target_pos)
		
		if distance <= stopping_distance:
			_start_wait_sequence()
		else:
			direction = (target_pos - global_position).normalized()

	# 3. Apply Velocity (Acceleration / Friction)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * max_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	# 4. Handle Rotation (UPDATED)
	var target_rotation_y = rotation.y # Default to current rotation so we don't snap
	
	if _is_waiting:
		# CASE A: If waiting, align with the specific rotation of the Pathway Node
		target_rotation_y = current_path.global_rotation.y
		
	elif direction.length() > 0.1:
		# CASE B: If moving, align with the movement direction
		target_rotation_y = atan2(-direction.x, -direction.z)

	# Apply the rotation smoothly regardless of which case we are in
	rotation.y = lerp_angle(rotation.y, target_rotation_y, turn_speed * delta)

	move_and_slide()

# --- Custom Functions ---

func _start_wait_sequence() -> void:
	_is_waiting = true
	
	var time_to_wait = current_path.wait_time
	
	if time_to_wait > 0:
		await get_tree().create_timer(time_to_wait).timeout
	
	_get_next_pathway()
	_is_waiting = false

func _get_next_pathway() -> void:
	_current_path_index += 1
	_current_path_index = _current_path_index % pathways.size()
	current_path = pathways[_current_path_index]
