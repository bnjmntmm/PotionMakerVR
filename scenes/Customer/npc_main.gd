extends Node3D

@onready var spawn_locations: Node3D = $SpawnLocations
@onready var finished_buying_marker: Marker3D = $FinishedBuyingMarker
@onready var store_front_marker: Marker3D = $StoreFrontMarker
@onready var store_inside_marker: Marker3D = $StoreInsideMarker

@onready var npc_root: Node3D = $NPC


const CUSTOMER = preload("res://scenes/Customer/customer.tscn")
var customerArray : Array = []

func _ready() -> void:
	for i in range(1):
		var new_customer = CUSTOMER.instantiate()
		var spawn_loc = spawn_locations.get_children().pick_random()
		new_customer.global_position = spawn_loc.global_position
		new_customer.finish_position = finished_buying_marker.global_position
		new_customer.store_front_position = store_front_marker.global_position
		new_customer.store_inside_position = store_inside_marker.global_position
		new_customer.name = "NPC_" + str(i)
		customerArray.append(new_customer)
		new_customer.finished_navigation.connect(reset_npc)
		
		npc_root.add_child(new_customer)
		
		
func reset_npc(npc_name : String) -> void:
	for customer in customerArray:
		if customer.name == npc_name:
			var new_spawn_loc = spawn_locations.get_children().pick_random()
			customer.global_position = new_spawn_loc.global_position
			customer.pick_random_recipe_and_reset()
			print("spawn new one at Position: ", str(customer.global_position))
			npc_root.add_child(customer)
	pass
