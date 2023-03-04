extends Node

signal reload_main_menu # For forcing the main menu to check whether save games exist or not
# to display correct button schema


# Camera signals
signal new_camera_position(new_position)


# Unit selection signals
signal selectable_selected(state: bool)
signal click_and_drag_selection_made(select_rectangle: Rect2)
signal selectable_select_state(selectable: Selectable, state: bool)
