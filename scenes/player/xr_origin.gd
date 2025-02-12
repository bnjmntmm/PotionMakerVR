extends XROrigin3D


func _process(delta: float) -> void:
	$Controller_Left/FPS.text = str(Engine.get_frames_per_second())
