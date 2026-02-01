class_name ProgressionManager
extends Node

var official_task_meter: float
var official_task_target: float

var spy_task_meter: float
var spy_task_target: float

var suspicion_meter: float
var suspicion_limit: float

var current_level: int
var max_level: int

var is_game_over: bool
var is_completed: bool

var time_limit: float
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalAccess.progression = self
	RemoteConfig.config_updated.connect(_load_config)
	timer.timeout.connect(_set_game_over)
	current_level = SaveManager.get_value().current_level
	
	_load_config()
	_start_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if timer.is_stopped() && (is_completed || is_game_over):
		return
	
	var time = _get_time_left()
	GlobalSignal.update_timer.emit(time[0], time[1])

func add_official_meter() -> void:
	official_task_meter += 1.0
	GlobalSignal.update_official_task_meter.emit(official_task_meter, official_task_target)
	_check_for_game_over()
	_check_for_completion()
	

func add_spy_meter() -> void:
	spy_task_meter += 1.0
	GlobalSignal.update_spy_task_meter.emit(spy_task_meter, spy_task_target)
	_check_for_game_over()
	_check_for_completion()

func add_suspicion_meter() -> void:
	suspicion_meter += 1.0
	GlobalSignal.update_suspicion_meter.emit(suspicion_meter, suspicion_limit)
	_check_for_game_over()
	_check_for_completion()


func _load_config() -> void:
	match current_level:
		1: 
			official_task_target = RemoteConfig.get_value("official_task_target_1")
			spy_task_target = RemoteConfig.get_value("spy_task_target_1")
			suspicion_limit = RemoteConfig.get_value("suspicion_limit_1")
		_: 
			official_task_target = RemoteConfig.get_value("official_task_target_1")
			spy_task_target = RemoteConfig.get_value("spy_task_target_1")
			suspicion_limit = RemoteConfig.get_value("suspicion_limit_1")
	

	
func _get_time_left():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _start_timer():
	timer.wait_time = time_limit
	timer.start()
	

func _check_for_completion() -> void:
	if is_game_over:
		return
	
	var is_official_task_completed: bool = official_task_meter >= official_task_target
	var is_spy_task_completed: bool = spy_task_meter >= spy_task_target
	
	if (is_official_task_completed && is_spy_task_completed):
		_set_completion()


func _check_for_game_over() -> void:
	if is_completed:
		return
	
	var is_suspicion_full: bool = suspicion_meter >= suspicion_limit
	
	if (is_suspicion_full):
		_set_game_over()
	

func _set_completion() -> void:
	is_completed = true;
	is_game_over = false
	GlobalSignal.on_completed.emit()


func _set_game_over() -> void:
	is_game_over = true;
	is_completed = false
	GlobalSignal.on_game_over.emit()
