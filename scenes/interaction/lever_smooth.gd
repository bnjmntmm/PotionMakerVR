extends Node3D
@onready var interactable_lever: XRToolsInteractableHinge = $LeverOrigin/InteractableLever


var is_currently_moved : bool = false

func _on_interactable_lever_hinge_moved(angle: Variant) -> void:
	if angle >= 45:
		if App.lever_can_be_pulled_down:
			App.lever_can_be_pulled_down = false
			print("emitted")
			App.lever_pushed_down.emit()
			

func _process(delta: float) -> void:
	if not is_currently_moved and not App.lever_can_be_pulled_down:
		interactable_lever.hinge_position = lerpf(interactable_lever.hinge_position,0.0,delta)
		if interactable_lever.hinge_position < 2:
			interactable_lever.hinge_position = 0.0
			App.lever_can_be_pulled_down = true


func _on_interactable_lever_grabbed(interactable: Variant) -> void:
	is_currently_moved = true


func _on_interactable_lever_released(interactable: Variant) -> void:
	is_currently_moved = false
