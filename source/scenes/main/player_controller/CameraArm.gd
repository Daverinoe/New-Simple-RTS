extends Node3D

@export_category("Camera movement")
@export_range(5, 50) var mouse_move_threshold : int = 20
@export_range(1, 50) var move_speed : float = 0
@export_range(0.1, 1) var pan_speed : float = 0.3

var screen_size : Vector2i
var move_direction : Vector2 = Vector2.ZERO
var middle_mouse : bool = false
var initial_mouse_position : Vector2 = Vector2.ZERO
var initial_camera_position : Vector3
var offset : Vector2 = Vector2.ZERO

var tween : Tween
var max_zoom : float = 10.0
var min_zoom : float = 0.5
var min_arm_rotation : float = 0
var max_arm_rotation : float = 70

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = DisplayServer.screen_get_size()
	
	Event.connect("new_camera_position", set_xz_position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				if event.is_pressed() and !middle_mouse:
					initial_mouse_position = Vector2.ZERO
					middle_mouse = true
				else:
					middle_mouse = false
			MOUSE_BUTTON_WHEEL_UP:
				set_zoom(self.position.y - 2.5, self.rotation_degrees.x + 20)
			MOUSE_BUTTON_WHEEL_DOWN:
				set_zoom(self.position.y + 2.5, self.rotation_degrees.x - 20)


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Check mouse position every frame
	check_mouse_boundaries()
	
	# Check for middle-click and drag
	if middle_mouse: click_and_drag(delta)
	
	self.position.x += move_direction.x * move_speed * delta
	self.position.z += move_direction.y * move_speed * delta


func check_mouse_boundaries() -> void:
	var mouse_position : Vector2i = get_viewport().get_mouse_position()
	
	# Check position and assign camera movement direction
	# Check X and Y separately so diagonals can be achieved
	if mouse_position.x < mouse_move_threshold:
		move_direction.x = -1
	elif mouse_position.x > screen_size.x - mouse_move_threshold:
		move_direction.x = 1
	else:
		move_direction.x = 0 
	
	if mouse_position.y < mouse_move_threshold:
		move_direction.y = -1
	elif mouse_position.y > screen_size.y - mouse_move_threshold:
		move_direction.y = 1
	else:
		move_direction.y = 0 


func set_zoom(new_zoom_level: float, new_arm_rotation: float) -> void:
	if tween != null:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self,
	"position:y",
	clamp(new_zoom_level, min_zoom, max_zoom),
	0.5)
	
	tween.parallel().tween_property(self,
	"rotation_degrees:x",
	clamp(new_arm_rotation, min_arm_rotation, max_arm_rotation),
	0.5)


func click_and_drag(delta: float) -> void:
	if initial_mouse_position == Vector2.ZERO:
		initial_mouse_position = get_viewport().get_mouse_position()
		initial_camera_position = self.position
	
	offset = initial_mouse_position - get_viewport().get_mouse_position()
	
	
	
	self.position.x = initial_camera_position.x + offset.x * pan_speed
	self.position.z = initial_camera_position.y + offset.y * pan_speed


func set_xz_position(new_position: Vector2) -> void:
	self.position.x = new_position.x
	self.position.z = new_position.y
	
