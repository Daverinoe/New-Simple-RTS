extends NavigationRegion3D


func _ready() -> void:
	call_deferred("rebake_navmesh")


func rebake_navmesh() -> void:
	self.bake_navigation_mesh()
