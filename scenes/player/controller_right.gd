extends XRController3D

@onready var function_pickup: XRToolsFunctionPickup = $FunctionPickup

const PICKABLE_POTION = preload("res://scenes/potion/pickable_potion.tscn")
var currentObjectToSpawn

var should_vibrate: bool = false

func _on_grab_collision_area_entered(area: Area3D) -> void:
	if area.name == "NewPotionArea":
		currentObjectToSpawn = PICKABLE_POTION
	else:
		## it will be a ingredient
		## replace 'new' with 'Pickable' as the Pickable Scenes are called same but instead the have
		## pickable in front
		var pickable_ingredientName = area.name.replace("New","Pickable")
		##then we need to find that in the App Global
		for pickable in App.pickable_ingredients:
			if pickable.name == pickable_ingredientName:
				currentObjectToSpawn = pickable


func _on_grab_collision_area_exited(area: Area3D) -> void:
	currentObjectToSpawn = null

func _physics_process(delta: float) -> void:
	if should_vibrate:
		trigger_haptic_pulse('haptic', 0.0, 0.08, -1.0, 0.0)



func _on_button_pressed(button_name: String) -> void:
	## was grib pressed and object is set -> instantiate it and put it into the hand as pickup object
	if button_name == "grip_click":
		if currentObjectToSpawn != null:
			var new_object
			if currentObjectToSpawn is RigidBody3D:
				new_object = currentObjectToSpawn.duplicate(8)
			else:
				new_object = currentObjectToSpawn.instantiate()
			App.PickableParent.add_child(new_object)
			function_pickup._pick_up_object(new_object)
			var pickupSound = new_object.get_node("PickupSound")
			if pickupSound:
				pickupSound.play()


func _on_function_pickup_has_picked_up(what: Variant) -> void:
	if what.name == "InteractableHandleSpoon":
		should_vibrate = true



func _on_function_pickup_has_dropped() -> void:
	should_vibrate = false
