extends CharacterBody2D

var start_pos: Vector2 # cannon location, to be written in main
var mouse_pos: Vector2 # the target point, to be written in main
@onready var time = $ReachTargetTimer.wait_time	 # time to reach target


var d_x: float
var vf_x: float = 50
var a_x: float
var vi_x: float


var d_y: float
var vf_y : float = -50	# final velocity at target
var a_y : float			# acceleration to reach target
var vi_y : float			# initial velocity to reach target
## NOTE: u,a calculated from v, T and displacement in _ready()

# d = vi*t + (1/2)*a*t^2
# vf = vi + a*t
# vf^2 = vi^2 + 2*a*d
# d = (vi+vf)*t/2 

func _ready() -> void:
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
	$ReachTargetTimer.start()
	
func _process(delta: float) -> void:
	velocity.x += a_x*delta
	velocity.y += a_y*delta
	move_and_slide()


func _on_physics_timer_timeout() -> void:
	# decrease "perceived" acceleration
	a_x /= 4
	a_y /= 4
