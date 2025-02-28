extends Node3D

@onready var interactable_hinge: XRToolsInteractableHinge = $SteeringOrigin/InteractableHinge
@onready var interactable_handle: XRToolsInteractableHandle = $SteeringOrigin/InteractableHinge/Handle/InteractableHandleSpoon

@onready var finish_sound: AudioStreamPlayer3D = $FinishSound
@onready var bubbling_water: AudioStreamPlayer3D = $BubblingWater
@onready var bubble_particles: GPUParticles3D = $BubbleParticles
@onready var flush_particles: GPUParticles3D = $FlushParticles
@onready var sploosh_sound: AudioStreamPlayer3D = $SplooshSound

@onready var house_main: Node3D = $"../HouseMain"


var liquid_material : StandardMaterial3D
var standard_color : Color

var current_Ingredients : Array = []
var cooked_recipe = null

##cauldron should be locked when cooked
var potion_brewed : bool = false




var bubblingSoundPlaying : bool = false

var current_spoon_value
var is_moving : bool = false



func _ready() -> void:
	App.recipe_cooked.connect(_on_recipe_cooked)
	App.lever_pushed_down.connect(clear_cauldron)
	liquid_material = $Cauldron/Cauldron_Circle.get_surface_override_material(0)
	standard_color = liquid_material.albedo_color
	App.instantiate_packed_scenes()

func _on_interactable_hinge_grabbed(interactable: Variant) -> void:
	is_moving = true



func _on_interactable_hinge_released(interactable: Variant) -> void:
	is_moving = false
	
func _physics_process(delta: float) -> void:
	if is_moving:
		current_spoon_value = interactable_hinge.hinge_position
		if current_spoon_value == 1090 and not potion_brewed:
			App.recipe_cooked.emit()
			


func _on_ingredient_area_body_entered(body: Node3D) -> void:
	if not potion_brewed:
		for child in body.find_children("*"):
			if child.is_in_group("Ingredient"):
				sploosh_sound.pitch_scale = randf_range(1.3,1.7)
				sploosh_sound.play()
				if not bubblingSoundPlaying:
					bubblingSoundPlaying = true
					bubble_particles.emitting = true
					bubbling_water.play()
				current_Ingredients.append(child.ingredient_resource)
				house_main.update_IngredientSprite(child.texture)
				change_color_of_liquid(child.ingredient_resource.water_tint)
		if current_Ingredients.size() == 1:
			interactable_hinge.visible = true
			interactable_handle.enabled = true
			
		if current_Ingredients.size() > 3:
			current_Ingredients.pop_front()
	body.queue_free()


## when the recipe is cooked:
## remove ability to throw in new ingredients
## play a ding sound
## let user "fill up" bottle and give to customer
## check if recipe is a valid recipe
func _on_recipe_cooked() -> void:
	bubbling_water.stop()
	potion_brewed = true
	bubble_particles.emitting = false
	finish_sound.play()
	
	##if recipe valid
	var recipe = check_recipes_for_ingredients()
	if recipe != null:
		cooked_recipe = recipe
		print("We cooked: ", cooked_recipe.recipe_name)
	
	pass


func change_color_of_liquid(new_color : Color) -> void:
	var current_color = liquid_material.albedo_color
	var opacity = current_color.a
	current_color = Color(current_color.r,current_color.g, current_color.b)
	var blended_color = current_color.blend(new_color)
	blended_color.a = opacity
	liquid_material.albedo_color = blended_color
	
	
## play smoke like particles
## turn the water to the blue
## reset the ingredients
func clear_cauldron() -> void:
	flush_particles.emitting = true
	bubbling_water.stop()
	await get_tree().create_timer(0.2).timeout
	bubble_particles.emitting = false
	interactable_hinge.visible = false
	interactable_handle.enabled = false
	potion_brewed = false
	cooked_recipe = null
	bubblingSoundPlaying = false

	interactable_hinge.hinge_position = 0.0
	liquid_material.albedo_color = standard_color
	current_Ingredients.clear()
	house_main.resetIngredientSprites()


##if bottle entered:
## check if potion brewed
## 
func _on_bottle_area_body_entered(body: Node3D) -> void:
	if potion_brewed:
		var potion_body =  body.get_child(1)
		potion_body.liquid_color = liquid_material.albedo_color
		if cooked_recipe != null:
			potion_body.recipe = cooked_recipe
		
func check_recipes_for_ingredients():
	for recipe in App.recipe_scenes:
		if recipe.ingredientsInRecipe == current_Ingredients:
			return recipe
	return null
