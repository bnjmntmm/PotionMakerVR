extends Node

## signal to remove texts
signal remove_tutorial_texts
var firstTime = true

signal show_plush

signal recipe_cooked
signal instantiated_recipe_scenes

## should emit when lever is pulled down
signal lever_pushed_down
var lever_can_be_pulled_down : bool = true


var PickableParent : Node3D

var packed_recipe_scenes = ["res://scenes/potion/Recipes/recipe_dragons_fire_guard.tscn", "res://scenes/potion/Recipes/recipe_ember_blood_surge.tscn", "res://scenes/potion/Recipes/recipe_ghostflight_essence.tscn", "res://scenes/potion/Recipes/recipe_soaring_ember_shield.tscn", "res://scenes/potion/Recipes/recipe_spectral_vitality_brew.tscn", "res://scenes/potion/Recipes/recipe_vital_renewal_elixir.tscn"]

var recipe_scenes : Array = []

var packed_ingredients_scenes = ["res://scenes/potion/IngredientPickables/pickable_crimson_leaf.tscn", "res://scenes/potion/IngredientPickables/pickable_dragons_eye_resin.tscn", "res://scenes/potion/IngredientPickables/pickable_griffin_feather.tscn", "res://scenes/potion/IngredientPickables/pickable_phoenix_ash.tscn", "res://scenes/potion/IngredientPickables/pickable_spectral_lily.tscn"]
var pickable_ingredients : Array = []


func instantiate_packed_scenes() -> void:
	for path in packed_recipe_scenes:
		var instance : PackedScene = load(path)
		var instantiated = instance.instantiate()
		recipe_scenes.append(instantiated)
	for path in packed_ingredients_scenes:
		var ingredient : PackedScene = load(path)
		var instantiated = ingredient.instantiate()
		pickable_ingredients.append(instantiated)
	instantiated_recipe_scenes.emit()
