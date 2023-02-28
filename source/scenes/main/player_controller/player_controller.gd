extends Node3D
class_name PlayerController


var minimap_viewport : SubViewport :
	set(new_viewport):
		set_minimap_viewport(new_viewport)

@onready var minimap_ref : TextureRect = %MiniMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_minimap_viewport(new_viewport : SubViewport) -> void:
	var new_texture : ViewportTexture = new_viewport.get_texture()
	minimap_ref.texture = new_texture
