extends Node3D

@export var available_task: BaseTask

var is_enemy_around: bool

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is PathfindingCharacterController:
		is_enemy_around = true
		return
	
	if is_enemy_around:
		return;
	
	GlobalSignal.on_task_enter.emit(available_task)


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body is PathfindingCharacterController:
		is_enemy_around = false
		return
	
	if is_enemy_around:
		return;
	
	GlobalSignal.on_task_exit.emit()
