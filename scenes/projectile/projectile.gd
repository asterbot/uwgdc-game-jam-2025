extends CharacterBody2D

var start_pos: Vector2 # cannon location, to be written to upon instantiation
var mouse_pos: Vector2 # the target point, to be written to upon instantiation
var target_depth: float # number of seconds to reach target, to be written to upon instantiation
@onready var timer = $ReachTargetTimer

var time: float
var time_left_normalized: float


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

func _ready() -> void:
	time = 1 - target_depth
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2(start_pos.x, viewport_size.y) # we shoot the projectile from here
	
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
	
	timer.wait_time = time
	timer.start()
	
	var tween_until_end: Tween = get_tree().create_tween()
	tween_until_end.set_parallel()
	tween_until_end.tween_property(self, "scale", Vector2(target_depth, target_depth), time)
	tween_until_end.tween_property(self, "rotation_degrees", 2000*time, 1.5*time)


func _process(delta: float) -> void:
	velocity.x += a_x*delta
	velocity.y += a_y*delta
	move_and_slide()
	
	time_left_normalized = timer.time_left/time
	self.z_index = floor(time_left_normalized*Globals.NUM_Z_INDICES)


func _on_reach_target_timer_timeout() -> void:
	# decrease "perceived" acceleration
	a_x /= 2
	a_y /= 2

	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.5*time)
	tween.tween_property(self, "modulate:a", 0.0, 0.5*time)
	await tween.finished
	queue_free()
