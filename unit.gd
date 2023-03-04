extends Selectable
class_name Unit




func set_group(on_screen: bool) -> void:
	if !on_screen and is_in_group("owned_units_on_screen"):
		remove_from_group("owned_units_on_screen")
		return
	
	if on_screen and in_game_owner == OWNERS.PLAYER:
		add_to_group("owned_units_on_screen")
