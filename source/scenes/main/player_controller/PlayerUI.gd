extends Control
class_name PlayerUI

# Selection rectangle variables
var initial_click_point : Vector2 = Vector2.ZERO
var select_rectangle : Rect2
var is_click_dragging : bool = false


func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("select_click") and !is_click_dragging:
		if !GlobalRefs.player_controller.multi_select:
			var selected = get_tree().get_nodes_in_group("player_selected")
			if selected.size() != 0:
				for node in selected:
					node.selected = false
			Event.emit_signal("change_portrait", "")
		initial_click_point = get_viewport().get_mouse_position()
		is_click_dragging = true
	
	if Input.is_action_just_released("select_click") and is_click_dragging:
		is_click_dragging = false
		Event.emit_signal("click_and_drag_selection_made", select_rectangle)
		queue_redraw()
	
	if is_click_dragging:
		select_rectangle = update_selection_rectangle(get_viewport().get_mouse_position())
		queue_redraw()


func _draw():
	if is_click_dragging:
		draw_rect(select_rectangle, Color(Color.CORNFLOWER_BLUE, 0.3))




func update_selection_rectangle(current_mouse_position: Vector2) -> Rect2:
	# TODO: Match direction of mouse movement to different corner starts
	var x_size : float = current_mouse_position.x - initial_click_point.x
	var y_size : float = current_mouse_position.y - initial_click_point.y
	
	return Rect2(initial_click_point, Vector2(x_size, y_size))

