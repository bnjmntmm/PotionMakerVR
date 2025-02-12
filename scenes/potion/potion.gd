extends Node3D
@export var liquid_color : Color = Color.BLACK:
	set(value):
		liquid_color = value
		var mat :StandardMaterial3D = $Liquid.get_material_override()
		mat.albedo_color = value
		
var recipe : BaseRecipe
