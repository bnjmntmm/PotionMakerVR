extends Node

signal recipe_cooked

## should emit when lever is pulled down
signal lever_pushed_down
var lever_can_be_pulled_down : bool = true

var packed_recipe_scenes = ["res://scenes/potion/Recipes/draconic_fire_ward.tscn","res://scenes/potion/Recipes/elixif_of_rejuvenation.tscn","res://scenes/potion/Recipes/featherlight_tonic.tscn","res://scenes/potion/Recipes/glacial_insight_elixir.tscn",
"res://scenes/potion/Recipes/ocean’s_whisper_brew.tscn","res://scenes/potion/Recipes/shadowsight_draught.tscn","res://scenes/potion/Recipes/stonefist_fortifier.tscn","res://scenes/potion/Recipes/twilight_veil_potion.tscn",
"res://scenes/potion/Recipes/venomous_might_brew.tscn"]

var recipe_scenes : Array = []


func instantiate_packed_scenes() -> void:
	for path in packed_recipe_scenes:
		var instance : PackedScene = load(path)
		var instantiated = instance.instantiate()
		recipe_scenes.append(instantiated)
