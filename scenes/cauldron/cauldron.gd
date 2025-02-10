extends Node3D
@onready var interactable_hinge: XRToolsInteractableHinge = $SteeringOrigin/InteractableHinge

var current_Ingredients : Array = []

var current_spoon_value
var is_moving : bool = false



func _on_interactable_hinge_grabbed(interactable: Variant) -> void:
	is_moving = true


func _on_interactable_hinge_released(interactable: Variant) -> void:
	is_moving = false
	
func _physics_process(delta: float) -> void:
	if is_moving:
		current_spoon_value = interactable_hinge.hinge_position
		$ProcentValue.text = "Value: " + str(snappedf(current_spoon_value,0.01))


func _on_ingredient_area_body_entered(body: Node3D) -> void:
	if current_Ingredients.size() > 5:
		current_Ingredients.pop_front()
		
	for child in body.find_children("*"):
		if child.is_in_group("Ingredient"):
			current_Ingredients.append(child.ingredient_name)
			body.queue_free()
	$Ingredients.text = str(current_Ingredients)
