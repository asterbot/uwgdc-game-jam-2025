class_name Balloon

extends CharacterBody2D


var entity_to_follow: Cat # gets set by creator

var viewport_size
var depth

func _ready() -> void:
	if (!entity_to_follow):
		assert(false, "No entity set to follow")
	
	$Area2D.collision_layer = Globals.BALLOON_LAYER
	$Area2D.collision_mask = Globals.NO_LAYER
	
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	
func _process(delta: float) -> void:
	# Adjust scale by depth
	viewport_size = get_viewport().get_visible_rect().size
	depth = position.y/viewport_size.y
	self.scale = Vector2(depth, depth)
	
	# Movement logic
	position = entity_to_follow.position
	velocity = entity_to_follow.velocity
	move_and_slide()

func drop_cat():
	entity_to_follow.drop()
	queue_free()
