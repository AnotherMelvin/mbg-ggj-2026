extends Node3D

@export var available_task: BaseTask

func _on_area_3d_body_entered(_body: Node3D) -> void:
	print("Entered!")


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("Exited!")
