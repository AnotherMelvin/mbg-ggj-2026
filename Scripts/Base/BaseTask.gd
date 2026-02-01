@abstract
class_name BaseTask extends Resource

@export var type: Utils.TASK_NAME_TYPE
@export var duration: float
@export var is_spy_task: bool

@abstract
func on_interact()

@abstract
func on_finish()
