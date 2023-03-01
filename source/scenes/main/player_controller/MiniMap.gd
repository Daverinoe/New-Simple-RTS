extends TextureRect

var map_size : Vector2 = Vector2.ZERO
var left_click_held : bool = false


func _on_gui_input(event: InputEvent) -> void:
	
	if ((event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT)
	or (event is InputEventMouseMotion and left_click_held)):
		if map_size == Vector2.ZERO:
			map_size = texture.get_size()
		
		convert_to_map_location_and_send_signal(event)
		left_click_held = true
	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and !event.is_pressed():
		left_click_held = false


func convert_to_map_location_and_send_signal(event) -> void:
	# Normalise event position to mini-map texture size, centered about (0, 0)
	var map_ratio = event.position / map_size - Vector2(0.5, 0.5)
	
	# Re-base event position to map size
	var new_camera_position = map_ratio * GlobalRefs.map_size
	
	Event.emit_signal("new_camera_position", new_camera_position)
