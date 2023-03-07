extends Control


var current_viewport : SubViewport = null


func _ready() -> void:
	Event.connect("change_portrait", change_viewport)


func change_viewport(viewport_name: String = "", selectable_owner : int = Selectable.OWNERS.PLAYER) -> void:
	if current_viewport != null:
		turn_off_current_viewport()
	
	if viewport_name == "":
		return
	
	var new_viewport_texture = get_viewport_texture(viewport_name, selectable_owner)
	if new_viewport_texture != null:
		$PortraitCameraView.texture = new_viewport_texture
	
	


func turn_off_current_viewport() -> void:
	current_viewport.get_child(0).visible = false
	$PortraitBackgroundColoured.visible = false
	$PortraitCameraView.texture = null


func get_viewport_texture(viewport_name: String, selectable_owner : int) -> ViewportTexture:
	for node in get_children():
		if node is SubViewport and node.name == viewport_name:
			current_viewport = node
			node.get_child(0).visible = true
			
			$PortraitBackgroundColoured.texture.gradient.set_color(0, GlobalRefs.SELECT_COLOURS[selectable_owner])
			$PortraitBackgroundColoured.visible = true
			return (node as SubViewport).get_texture()
	
	return null
