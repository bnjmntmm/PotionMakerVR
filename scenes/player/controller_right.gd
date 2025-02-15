extends XRController3D

@onready var function_pickup: XRToolsFunctionPickup = $FunctionPickup

const PICKABLE_POTION = preload("res://scenes/potion/pickable_potion.tscn")
var currentObjectToSpawn


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
