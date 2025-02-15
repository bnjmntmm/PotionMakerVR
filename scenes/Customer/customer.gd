extends CharacterBody3D

signal finished_navigation(npc_name)

const JOY_2 = preload("res://Assets/Sounds/customer/joy2.mp3")
const JOY_3 = preload("res://Assets/Sounds/customer/joy3.mp3")
const JOY = preload("res://Assets/Sounds/customer/joy.mp3")
const MUMBLING_MAN = preload("res://Assets/Sounds/customer/mumblingMan.ogg")

@onready var quest_panel: MeshInstance3D = $QuestPanel
@onready var quest_text: Label3D = $QuestPanel/Quest 
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var potion_snap_zone: XRToolsSnapZone = $PotionSnapZone
@onready var animation_tree: AnimationTree = $AnimationTree

const SPEED = 2
const ACCEL = 10

var store_front_position : Vector3
var store_inside_position : Vector3
var finish_position : Vector3
var should_move : bool = false

var wanted_potion : BaseRecipe
var angry_customer : bool = false
var has_potion : bool = false

var wrong_potion_counter  = 0


 
func _ready() -> void:
	pick_random_recipe_and_reset()
	nav_agent.target_position = store_front_position
	$MumblingSound.stream = MUMBLING_MAN
	
	var randomJoy := [JOY, JOY_2, JOY_3]
	var joy = randomJoy.pick_random()
	$JoySound.stream = joy

func pick_random_recipe_and_reset() -> void:
	wanted_potion = App.recipe_scenes.pick_random()
	quest_text.text = wanted_potion.potion_quest_array.pick_random()
	should_move = true
	has_potion = false
	angry_customer = false
	nav_agent.target_position = store_front_position
	quest_panel.visible = false
	potion_snap_zone.visible = false
	wrong_potion_counter = 0
	if potion_snap_zone.picked_up_object != null:
		potion_snap_zone.picked_up_object.queue_free()
	potion_snap_zone.picked_up_object = null
	

func _physics_process(delta: float) -> void:
	if should_move:
		var direction = Vector3()
		var next_path_position = nav_agent.get_next_path_position()
		direction = next_path_position - global_position
		#look_at(Vector3(next_path_position.x,2,next_path_position.z))
		look_at(Vector3(next_path_position.x,0.8,next_path_position.z))
		direction = direction.normalized()
		velocity = velocity.lerp(direction * SPEED, ACCEL * delta)
		move_and_slide()
	else:
		look_at(store_inside_position)
		velocity = Vector3(0,0,0)
	update_animation_parameters(delta)
		
func _on_potion_snap_zone_has_picked_up(what: Variant) -> void:
	var potion = what.get_node("Potion")
	if potion != null:
		var potion_recipe = potion.recipe
		if wanted_potion == potion_recipe:
			## if potion received. wait a bit and then go away.. 
			quest_text.text = "Ahh thank you! That will definitely help me!"
			nav_agent.target_position = finish_position
			quest_panel.visible = false
			$JoySound.play()
			potion_snap_zone.visible = false
			await get_tree().create_timer(1).timeout
			should_move = true
			has_potion = true
			
		else:
			if wrong_potion_counter >= 3:
				quest_text.text = "You're such a bad Potion Maker! You will hear from me!"
				nav_agent.target_position = finish_position
				$MumblingSound.play()
				await get_tree().create_timer(1.5).timeout
				should_move = true
				angry_customer = true
				quest_panel.visible = false
				potion_snap_zone.visible = false
				
			wrong_potion_counter += 1
			quest_text.text = "No! That is not what I wanted... Please make the right Potion"
			await get_tree().create_timer(2).timeout
			quest_text.text = wanted_potion.potion_quest_array.pick_random()


func _on_navigation_agent_3d_navigation_finished() -> void:
	quest_panel.visible = true
	potion_snap_zone.visible = true
	should_move = false
	
	if has_potion:
		get_parent().remove_child(self)
		finished_navigation.emit(name)
		
	elif angry_customer:
		get_parent().remove_child(self)
		finished_navigation.emit(name)

	else:
		print("Position: ", global_position, "-- Looking at: ", store_inside_position)
		look_at(store_inside_position)
		

func update_animation_parameters(delta: float) -> void:
	# Get the current blend value
	var current_blend = animation_tree["parameters/WalkIdle/blend_position"]
	
	# Determine target blend value:
	# When moving (speed > threshold) we target -1.0, otherwise we target 0.
	var target_blend = -1.0 if velocity.length() > 0.1 else 0.0
	
	# Adjust this rate for how quickly you want the blend to update
	var blend_rate = 5.0
	current_blend = lerp(current_blend, target_blend, blend_rate * delta)
	
	# Update the blend value in the animation tree
	animation_tree["parameters/WalkIdle/blend_position"] = current_blend
