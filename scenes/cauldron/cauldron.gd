extends Node3D

@onready var interactable_hinge: XRToolsInteractableHinge = $SteeringOrigin/InteractableHinge
@onready var finish_sound: AudioStreamPlayer3D = $FinishSound
@onready var bubbling_water: AudioStreamPlayer3D = $BubblingWater
@onready var bubble_particles: GPUParticles3D = $BubbleParticles

var liquid_material : StandardMaterial3D

var current_Ingredients : Array = []

##cauldron should be locked when cooked
var potion_brewed : bool = false

var bubblingSoundPlaying : bool = false

var current_spoon_value
var is_moving : bool = false

@onready var house_main: Node3D = $"../HouseMain"


func _ready() -> void:
	App.recipe_cooked.connect(_on_recipe_cooked)
	liquid_material = $Cauldron/Cauldron_Circle.get_surface_override_material(0)


func _on_interactable_hinge_grabbed(interactable: Variant) -> void:
	is_moving = true


func _on_interactable_hinge_released(interactable: Variant) -> void:
	is_moving = false
	
func _physics_process(delta: float) -> void:
	if is_moving:
		current_spoon_value = interactable_hinge.hinge_position
		$ProcentValue.text = "Value: " + str(snappedf(current_spoon_value,0.01))
		if current_spoon_value == randi_range(980, 1080) and not potion_brewed:
			App.recipe_cooked.emit()
			


func _on_ingredient_area_body_entered(body: Node3D) -> void:
	if not potion_brewed:
		if current_Ingredients.size() > 5:
			current_Ingredients.pop_front()
			
		for child in body.find_children("*"):
			if child.is_in_group("Ingredient"):
				if not bubblingSoundPlaying:
					bubblingSoundPlaying = true
					bubble_particles.emitting = true
					bubbling_water.play()
				current_Ingredients.append(child.ingredient_resource.ingredient_name)
				house_main.update_IngredientSprite(child.texture)
				change_color_of_liquid(child.ingredient_resource.water_tint)
	body.queue_free()


## when the recipe is cooked:
## remove ability to throw in new ingredients
## play a ding sound
## let user "fill up" bottle and give to customer
func _on_recipe_cooked() -> void:
	bubbling_water.stop()
	potion_brewed = true
	bubble_particles.emitting = false
	finish_sound.play()
	pass


func change_color_of_liquid(new_color : Color) -> void:
	var current_color = liquid_material.albedo_color
	var opacity = current_color.a
	current_color = Color(current_color.r,current_color.g, current_color.b)
	var blended_color = current_color.blend(new_color)
	blended_color.a = opacity
	liquid_material.albedo_color = blended_color
	
	
	
