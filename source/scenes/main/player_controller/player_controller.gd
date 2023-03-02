extends Node3D
class_name PlayerController

@export var camera : Camera3D
const RAY_LENGTH : float = 5000.0



func _ready() -> void:
	Event.connect("click_and_drag_selection_made", select_from_rectangle)



var minimap_viewport : SubViewport :
	set(new_viewport):
		set_minimap_viewport(new_viewport)

@onready var minimap_ref : TextureRect = %MiniMap




func set_minimap_viewport(new_viewport : SubViewport) -> void:
	var new_texture : ViewportTexture = new_viewport.get_texture()
	minimap_ref.texture = new_texture



func select_from_rectangle(rectangle: Rect2) -> void:
	var start_corner : Vector2 = rectangle.position
	var end_corner : Vector2 = rectangle.end
	
	var corner_array : Array = [start_corner, end_corner]
	var world_3d_corner_array : Array = []
	
	for corner in corner_array:
		world_3d_corner_array.append(cast_ray_from_camera(corner))
	
	check_for_units_inside_rectangle(world_3d_corner_array)


func cast_ray_from_camera(initial_position : Vector2) -> Vector2:
	
	var from = camera.project_ray_origin(initial_position)
	var to = from + camera.project_ray_normal(initial_position) * RAY_LENGTH
	
	var space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	return Vector2.ZERO


func check_for_units_inside_rectangle(rectangle_corners: Array) -> void:
	var owned_units_on_screen = get_tree().get_nodes_in_group("owned_on_screen")
	if owned_units_on_screen.size() == 0:
		return
	
	for node in owned_units_on_screen:
		if unit_is_in_selection_rectangle(node, rectangle_corners):
			node.select()


func unit_is_in_selection_rectangle(unit_node, rectangle_corners: Array) -> bool:
	var min_x = min(rectangle_corners[0].x, rectangle_corners[1].x)
	var max_x = max(rectangle_corners[0].x, rectangle_corners[1].x)
	var min_y = min(rectangle_corners[0].y, rectangle_corners[1].y)
	var max_y = max(rectangle_corners[0].y, rectangle_corners[1].y)
	
	var unit_position : Vector2 = unit_node.global_transform.origin
	
	if (unit_position.x < min_x 
	or unit_position.x > max_x
	or unit_position.y < min_y
	or unit_position.y > max_y):
		return false
	
	return true
