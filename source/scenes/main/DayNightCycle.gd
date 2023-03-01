extends DirectionalLight3D

@export_category("Day/Night cycle variables")
@export_range(0, 120) var cycle_time : float = 60
@export var cycle_on : bool = true

var start_degrees : float = 270.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_day_night()


func _process(delta: float) -> void:
#	if self.rotation_degrees.x < 180.0:
#		self.light_energy = 0
	if self.rotation_degrees.x > 180.0:
		self.light_energy = 1


func start_day_night() -> void:
	var tween : Tween = get_tree().create_tween()
	
	tween.tween_property(
		self,
		"rotation_degrees:x",
		start_degrees + 360,
		cycle_time
	)
	
	await tween.finished
	self.rotation_degrees.x = start_degrees
	if cycle_on:
		start_day_night()
