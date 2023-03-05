extends CharacterBody3D
class_name Selectable

enum OWNERS {
	PLAYER = 0,
	AI = 1,
}

@export_category("Selection Variables")
@export_enum("PLAYER", "AI", "NEUTRAL") var in_game_owner : int
@export var selection_circle : Sprite3D

@export_category("Stats")
@export var max_health : int = 150
@export var current_health : int = 150
@export var max_mana : int = 0
@export var current_mana : int = 0
@export_enum("NORMAL", "PIERCING", "MAGIC") var damage_type : int
@export var min_damage : float = 0.0
@export var max_damage : float = 0.0
@export_enum("LIGHT", "HEAVY", "FORTIFIED") var armour_type : int
@export var armour : float = 1.0

@export_category("Visibility variables")
@export var visibility_notifier : VisibleOnScreenNotifier3D

@export_category("Animation variables")
@export var animation_player : AnimationPlayer
@export var animation_tree : AnimationTree
@onready var state_machine = animation_tree["parameters/playback"]


var owner_names : Dictionary = {
	0: "player",
	1: "ai",
	2: "neutral",
}


var selected : bool = false :
	get:
		return selected
	set(select_state):
		selected = select_state
		selection_circle.visible = select_state
		check_and_set_select_group()
		Event.emit_signal("selectable_select_state", self, select_state)


func _ready():
	
	var owner_prefix : String = "owned_by_"
	add_to_group(owner_prefix + owner_names[in_game_owner])
	
	# Connect signal to lambda that redirects to selected setter
	Event.connect("selectable_selected", func(state): selected = state)
	self.connect("input_event", _on_input_event)
	
	
	visibility_notifier.connect("screen_entered", set_group.bind(true))
	visibility_notifier.connect("screen_exited", set_group.bind(false))


func check_and_set_select_group() -> void:
	if !selected and is_in_group("player_selected"):
			remove_from_group("player_selected")
			return
	
	if in_game_owner != OWNERS.PLAYER or !GlobalRefs.player_controller.multi_select:
		for node in get_tree().get_nodes_in_group("player_selected"):
			node.selected = false
	
	add_to_group("player_selected")


func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !self.selected:
		self.selected = true


func set_group(is_visible: bool) -> void:
	# To override
	pass
