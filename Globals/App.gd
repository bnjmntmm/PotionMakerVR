extends Node

signal recipe_cooked
signal instantiated_recipe_scenes

## should emit when lever is pulled down
signal lever_pushed_down
var lever_can_be_pulled_down : bool = true

var packed_recipe_scenes = ["res://scenes/potion/Recipes/recipe_dragons_fire_guard.tscn", "res://scenes/potion/Recipes/recipe_ember_blood_surge.tscn", "res://scenes/potion/Recipes/recipe_ghostflight_essence.tscn", "res://scenes/potion/Recipes/recipe_soaring_ember_shield.tscn", "res://scenes/potion/Recipes/recipe_spectral_vitality_brew.tscn", "res://scenes/potion/Recipes/recipe_vital_renewal_elixir.tscn"]

var recipe_scenes : Array = []


func instantiate_packed_scenes() -> void:
	for path in packed_recipe_scenes:
		var instance : PackedScene = load(path)
		var instantiated = instance.instantiate()
		recipe_scenes.append(instantiated)
	instantiated_recipe_scenes.emit()
