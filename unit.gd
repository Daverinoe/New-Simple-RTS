extends Selectable
class_name Unit

@export_category("Movement variables")
@export var movement_speed : float = 2.0
@export var turn_speed : float = 0.2
@export var navigation_agent : NavigationAgent3D


func _ready() -> void:
	super()
	
	axis_lock_angular_x = true
	axis_lock_angular_z = true
	
	# Don't call await during ready, will cause issues.
	call_deferred("setup_actor")


func _physics_process(delta: float) -> void:
	
	if navigation_agent.is_navigation_finished():
		state_machine.travel("IDLE")
		return
	
	var current_agent_position : Vector3 = global_transform.origin
	var next_path_position : Vector3 = navigation_agent.get_next_path_position()
	
	if current_agent_position != next_path_position:
		turn_to_look_at(current_agent_position, next_path_position)
	
	var new_direction : Vector3 = next_path_position - current_agent_position
	new_direction = new_direction.normalized()
	var new_velocity : Vector3 = new_direction * movement_speed
	
	set_velocity(new_velocity)
	move_and_slide()


func turn_to_look_at(position, next_position) -> void:
	var current_quat : Quaternion = global_transform.basis.get_rotation_quaternion()
	var next_quat : Quaternion = global_transform.looking_at(next_position).basis.get_rotation_quaternion()
	
	if current_quat == next_quat:
		return
	
	var tween : Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(self,
		"quaternion",
		next_quat,
		turn_speed
	)



func setup_actor() -> void:
	# Wait for the first physics frame so the Navigation Server syncs
	await get_tree().physics_frame
	
	move(global_transform.origin)


func set_group(on_screen: bool) -> void:
	if !on_screen and is_in_group("owned_units_on_screen"):
		remove_from_group("owned_units_on_screen")
		return
	
	if on_screen and in_game_owner == OWNERS.PLAYER:
		add_to_group("owned_units_on_screen")


func move(destination: Vector3) -> void:
	navigation_agent.set_target_position(destination)
	state_machine.travel("MOVE")


func attack(object_to_attack) -> void:
	pass


func patrol(patrol_destination: Vector3) -> void:
	pass


func stop() -> void:
	move(global_transform.origin)


func hold_position() -> void:
	move(global_transform.origin)

