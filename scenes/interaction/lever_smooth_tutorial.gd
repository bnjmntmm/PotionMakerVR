extends Node3D
@onready var interactable_lever: XRToolsInteractableHinge = $LeverOrigin/InteractableLever


var is_currently_moved : bool = false

func _on_interactable_lever_hinge_moved(angle: Variant) -> void:
	if angle >= 45:
		App.remove_tutorial_texts.emit()
	if angle <= -45:
		App.show_plush.emit()

func _physics_process(delta: float) -> void:
	if not is_currently_moved and not interactable_lever.hinge_position == 0.0:
		interactable_lever.hinge_position = lerpf(interactable_lever.hinge_position,0.0,delta)
		if interactable_lever.hinge_position < 2:
			interactable_lever.hinge_position = 0.0
			


func _on_interactable_lever_grabbed(interactable: Variant) -> void:
	is_currently_moved = true


func _on_interactable_lever_released(interactable: Variant) -> void:
	is_currently_moved = false
