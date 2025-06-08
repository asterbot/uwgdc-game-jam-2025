extends Node2D


var depth: float
var viewport_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.collision_layer = Globals.OBSTACLE_LAYER
	$Area2D.collision_mask = Globals.NO_LAYER
	
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	self.scale = Vector2(depth*2, depth*2)
	
	self.z_index = floor(depth*Globals.NUM_Z_INDICES)
	
	self.modulate.a = 0.0
	$Area2D/CollisionPolygon2D.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.25)
	await tween.finished
	$Area2D/CollisionPolygon2D.disabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func destroy() -> void:
	$Area2D/CollisionPolygon2D.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	await tween.finished
	queue_free()
