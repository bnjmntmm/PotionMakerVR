extends Node3D

var currentIndex = 0
@onready var recipe_panel: MeshInstance3D = $RecipePanel

func update_IngredientSprite(newTexture):
	if currentIndex < recipe_panel.get_child_count():
		var child : Sprite3D = recipe_panel.get_child(currentIndex)
		if child:
			child.texture = newTexture
	currentIndex += 1
		

func resetIngredientSprites():
	currentIndex = 0
	for sprite : Sprite3D in recipe_panel.get_children():
		sprite.texture = null
