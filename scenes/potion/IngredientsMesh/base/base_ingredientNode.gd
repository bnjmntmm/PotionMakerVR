@tool
extends MeshInstance3D

class_name Ingredient

@export var texture : Texture:
	set(value):
		texture = value
		var texture = get_material_override()
		texture.albedo_texture = value
		
@export var ingredient_resource : IngredientResource
