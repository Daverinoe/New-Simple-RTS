extends Node
# Contains references to nodes that need to be preserved across scenes

var in_game_menu_ref := preload("res://source/scenes/menus/in_game_menu.tscn")
var settings_menu_ref := preload("res://source/scenes/menus/settings/settings.tscn")
var save_menu_ref := preload("res://source/scenes/menus/serials/save.tscn")
var load_menu_ref := preload("res://source/scenes/menus/serials/load.tscn")

var main_menu_path := "res://source/scenes/menus/main_menu/main_menu.tscn"


var level_ref
var active_menu
var active_scene

# Maps refs
var map_size : Vector2


# Minimap refs
var minimap_viewport : SubViewport


# Controller refs
var player_controller : PlayerController


# Player colours
var SELECT_COLOURS : Dictionary = {
	Selectable.OWNERS.PLAYER: Color(0, 0, 1),
	Selectable.OWNERS.AI: Color(1, 0, 0),
	Selectable.OWNERS.NEUTRAL: Color(1, 1, 0),
}
