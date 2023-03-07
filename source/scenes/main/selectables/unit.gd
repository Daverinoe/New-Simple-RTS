extends Selectable
class_name Unit

@export_category("Movement")
@export var movement_speed : float = 2.0
@export var turn_speed : float = 0.2

@export_group("Navigation variables")
@export var navigation_agent : NavigationAgent3D


func _ready() -> void:
	super()
	
	axis_lock_angular_x = true
	axis_lock_angular_z = true
	self.floor_constant_speed = true
	
	# Don't call await during ready, will cause issues.
	call_deferred("setup_actor")
	call_deferred("random_idle_change")
	
	navigation_agent.connect("velocity_computed", set_safe_velocity)


func random_idle_change() -> void:
	await get_tree().create_timer(randf_range(4, 10)).timeout
	if state_machine.get_current_node() == "IDLE":
		state_machine.travel("IDLE_LONG")
	
	random_idle_change()


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
	navigation_agent.set_velocity(new_direction * movement_speed)
	
	move_and_slide()


func set_safe_velocity(velocity_from_server: Vector3) -> void:
	set_velocity(velocity_from_server)


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


func context_action_click(position: Vector3) -> void:
	move(position)


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
	# Check to see if in group, then offset target position by position in group.
	var group_size = get_tree().get_nodes_in_group("player_selected").size()
	if group_size > 1:
		destination += Vector3(randf() * group_size, 0, randf() * group_size)
	
	destination.y = 0
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

