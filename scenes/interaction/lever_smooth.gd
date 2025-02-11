extends Node3D


func _on_interactable_lever_hinge_moved(angle: Variant) -> void:
	print("angle: ", str(angle))
