extends Node2D

var projectiles_in_range = []

var depth: float
var viewport_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	self.scale = Vector2(depth*1.5, depth*1.5)
	
	self.z_index = floor(depth*Globals.NUM_Z_INDICES)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for proj in projectiles_in_range:
		if proj.time_left_normalized > 0 and \
			proj.time_left_normalized < depth and depth < proj.time_left_normalized + 0.3:
			print("Bush hit! No damages here")
			proj.queue_free()
			break
	pass


func _on_area_2d_area_entered(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.append(projectile)


func _on_area_2d_area_exited(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.erase(projectile)
