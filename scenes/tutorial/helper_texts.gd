extends Node3D

var children_visible = true

func _ready() -> void:
	App.remove_tutorial_texts.connect(_on_remove_tutorial_texts)
	
	
func _on_remove_tutorial_texts() -> void:
	if children_visible:
		for child in get_children():
			if child is Label3D:
				child.visible = false
		children_visible = false
		$LeverSmooth/TutorialTexts.text = "Turn Tutorial Texts on"
	else:
		for child in get_children():
			if child is Label3D:
				child.visible = true
		children_visible = true
		$LeverSmooth/TutorialTexts.text = "Turn Tutorial Texts off"
