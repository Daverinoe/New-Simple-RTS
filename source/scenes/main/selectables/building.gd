extends Selectable

class_name Building

func _ready() -> void:
	super()
	add_to_group("navmesh_data_source")


func set_group(on_screen: bool) -> void:
	if !on_screen and is_in_group("owned_buildings_on_screen"):
		remove_from_group("owned_buildings_on_screen")
		return
	
	if on_screen and in_game_owner == OWNERS.PLAYER:
		add_to_group("owned_buildings_on_screen")


func context_action_click(position: Vector3) -> void:
	pass
