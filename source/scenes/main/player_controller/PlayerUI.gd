extends Control

# Selection rectangle variables
var initial_click_point : Vector2 = Vector2.ZERO
var select_rectangle : Rect2
var is_click_dragging : bool = false


func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("ui_select"):
		if !is_click_dragging:
			initial_click_point = get_viewport().get_mouse_position()
			is_click_dragging = true
	if event is InputEventMouseMotion and is_click_dragging:
		select_rectangle = update_selection_rectangle(get_viewport().get_mouse_position())
		queue_redraw()
	elif event.is_action_released("ui_select"):
		is_click_dragging = false
		queue_redraw()



func _draw():
	if is_click_dragging:
		print(select_rectangle)
		draw_rect(select_rectangle, Color(Color.CORNFLOWER_BLUE, 0.3))




func update_selection_rectangle(current_mouse_position: Vector2) -> Rect2:
	# TODO: Match direction of mouse movement to different corner starts
	var x_size : float = current_mouse_position.x - initial_click_point.x
	var y_size : float = current_mouse_position.y - initial_click_point.y
	
	return Rect2(initial_click_point, Vector2(x_size, y_size))
