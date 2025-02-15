extends Node3D

var currentIndex = 0
@onready var recipe_panel: MeshInstance3D = $RecipePanel

func _ready() -> void:
	App.show_plush.connect(_show_plus)

func _show_plus() -> void:
	$GodotPlush.visible = true

func update_IngredientSprite(newTexture):
	if currentIndex < recipe_panel.get_child_count():
		var child : Sprite3D = recipe_panel.get_child(currentIndex)
		if child:
			child.texture = newTexture
	currentIndex += 1
	currentIndex = currentIndex % 3
		

func resetIngredientSprites():
	currentIndex = 0
	for sprite : Sprite3D in recipe_panel.get_children():
		sprite.texture = null
