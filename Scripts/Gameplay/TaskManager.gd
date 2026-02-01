class_name TaskManager
extends Node

@export var tasks_list: Array[BaseTask]

func _ready() -> void:
	GlobalAccess.tasks = self
	RemoteConfig.config_updated.connect(_load_config)
	_load_config()

func _load_config() -> void:
	for task in tasks_list:
		match task.type:
			Utils.TASK_NAME_TYPE.ARCHIVE_FETCH:
				task.duration = RemoteConfig.get_value("archive_fetch_duration")
			Utils.TASK_NAME_TYPE.ARCHIVE_SAVE:
				task.duration = RemoteConfig.get_value("archive_save_duration")
			Utils.TASK_NAME_TYPE.ARCHIVE_SHRED:
				task.duration = RemoteConfig.get_value("archive_shred_duration")
