extends Node3D
@onready var liquid: MeshInstance3D = $Liquid

@export_range(0.35,0.8,0.01) var fill_amount : float = 0:
	set(value):
		fill_amount = value
		if liquid:
			liquid.liquidShaderMaterial.set_shader_parameter("fill_amount",value)
