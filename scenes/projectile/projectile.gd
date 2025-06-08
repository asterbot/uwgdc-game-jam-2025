extends CharacterBody2D

var start_pos: Vector2 # cannon location, to be written to upon instantiation
var mouse_pos: Vector2 # the target point, to be written to upon instantiation
var target_depth: float # number of seconds to reach target, to be written to upon instantiation
@onready var reach_timer_node = $ReachTargetTimer
@onready var total_uptime_timer_node = $TotalUptimeTimer

var time: float
var time_left_normalized: float
var time_until_target: float
var total_uptime_scale: float = 1.5

var depth: float
var has_hit: bool = false
var cats_in_range = []
var obstacles_in_range = []

var d_x: float
var vf_x: float = 50
var a_x: float
var vi_x: float

var d_y: float
var vf_y : float = -100 # final velocity at target
var a_y : float			# acceleration to reach target
var vi_y : float		# initial velocity to reach target
## NOTE: u,a calculated from v, T and displacement in _ready()

# d = vi*t + (1/2)*a*t^2
# vf = vi + a*t
# vf^2 = vi^2 + 2*a*d
# d = (vi+vf)*t/2 

signal notify_cat_hit(points) # tells the Score node that a cat is hit, and how many points

func _ready() -> void:
	print("PROJECTILE TARGET DEPTH: ", target_depth)
	$Area2D.collision_layer = Globals.PROJECTILE_LAYER
	$Area2D.collision_mask = Globals.CAT_LAYER + Globals.OBSTACLE_LAYER
	
	time = 1 - target_depth
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2(start_pos.x, viewport_size.y) # we shoot the projectile from here
	$Area2D/CollisionShape2D.disabled = false
	
	d_x = mouse_pos.x - position.x
	if (d_x < 0): vf_x *= -1
	if (abs(d_x/time) < abs(vf_x)): vf_x = d_x/time # if constant speed is slower, take that instead
	vi_x = 2*d_x/time - vf_x # calculate initial velocity
	velocity.x = vi_x
	a_x = (vf_x-vi_x)/time # acceleration
	
	d_y = -1 * abs(position.y - mouse_pos.y) # remember to negate
	vi_y = 2*d_y/time - vf_y # calculate initial velocity
	velocity.y = vi_y
	a_y = (vf_y-vi_y)/time # acceleration
	
	reach_timer_node.wait_time = max(0.01, time)
	total_uptime_timer_node.wait_time = max(0.01, total_uptime_scale*time)
	reach_timer_node.start()
	total_uptime_timer_node.start()
	
	var initial_rotation_deg: float = randf_range(0, 360)
	rotation_degrees = initial_rotation_deg
	var tween_until_end: Tween = get_tree().create_tween()
	tween_until_end.set_parallel()
	tween_until_end.tween_property(self, "scale", Vector2(target_depth, target_depth), time)
	tween_until_end.tween_property(self, "rotation_degrees", 1800*time + initial_rotation_deg, total_uptime_scale*time)


func _process(delta: float) -> void:
	velocity.x += a_x*delta
	velocity.y += a_y*delta
	move_and_slide()
	
	var timer_difference = (total_uptime_scale - 1) * reach_timer_node.wait_time # time from total_uptime that exceeds time until the target
	time_until_target = total_uptime_timer_node.time_left - timer_difference # like the normal timer, but goes negative once past the target
	time_left_normalized = reach_timer_node.time_left/time
	depth = target_depth + time_until_target
	self.z_index = floor(depth * Globals.NUM_Z_INDICES)
	
	# in this time, the projectile can hit things
	if -0.05 < time_until_target and time_until_target < 0.05:
		$Area2D/CollisionShape2D.disabled = false
		# find which obstacle/cat is eligible to be hit (i.e. greatest z_index)
		obstacles_in_range.sort_custom(func(node1, node2): return node1.z_index > node2.z_index)
		cats_in_range.sort_custom(func(node1, node2): return node1.z_index > node2.z_index)
		
		if len(obstacles_in_range) == 0 and len(cats_in_range) == 0: # no obstacles or cats to be hit
			pass
		elif len(obstacles_in_range) > 0 and len(cats_in_range) == 0: # only obstacles are eligible to be hit
			print("ONLY OBSTACLE HIT")
			destroy()
		elif len(obstacles_in_range) == 0 and len(cats_in_range) > 0: # only cats are eligible to be hit, pick first one
			print("ONLY CAT HIT")
			emit_signal("notify_cat_hit", 100)
			cats_in_range[0].destroy()
			destroy()
		else: # else, choose the closest node each kind
			var eligible_obstacle = obstacles_in_range[0]
			var eligible_cat = cats_in_range[0]
			if eligible_cat.z_index > eligible_obstacle.z_index: # if cat is in front of obstacle, hit the cat
				print("FRONT CAT HIT")
				emit_signal("notify_cat_hit", 100)
				cats_in_range[0].destroy()
				destroy()
			else:
				print("FRONT OBSTACLE HIT")
				destroy()
		
		# delete if obstacle is in the way
	else:
		$Area2D/CollisionShape2D.disabled = true

func _on_reach_target_timer_timeout() -> void:
	# decrease "perceived" acceleration
	a_x /= 2
	a_y /= 2

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2.ZERO, (total_uptime_scale-1)*time)
	tween.tween_property(self, "modulate:a", 0.0, (total_uptime_scale-1)*time)
	await tween.finished
	queue_free()
	print("PROJ DESTROYED")

func destroy() -> void:
	queue_free()

# these area functions only run once the projectile hits its required depth and turns on its hitbox
func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer == Globals.CAT_LAYER):
		cats_in_range.append(area.get_parent())
	elif (area.collision_layer == Globals.OBSTACLE_LAYER):
		obstacles_in_range.append(area.get_parent())

func _on_area_2d_area_exited(area: Area2D) -> void:
	if (area.collision_layer == Globals.CAT_LAYER):
		cats_in_range.erase(area.get_parent())
	elif (area.collision_layer == Globals.OBSTACLE_LAYER):
		obstacles_in_range.erase(area.get_parent())
