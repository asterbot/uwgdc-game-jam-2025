extends CharacterBody2D

var mouse_position: Vector2 # to be written in main
var displacement: float
@onready var T = $PhysicsTimer.wait_time	# time to reach target

var v : float = 0	# final velocity at target
var a : float			# acceleration to reach target
var u : float			# initial velocity to reach target
## NOTE: u,a calculated from v, T and displacement in _ready()

# s = ut + (1/2)at^2
# v = u + at
# v^2 = u^2 + 2as
# s = (v+u)*t/2 

func _ready() -> void:
	position = Vector2(mouse_position.x, Globals.SCREEN_HEIGHT)
	displacement = -1 * abs(position.y - mouse_position.y)
	u = 2*displacement/(T) - v
	a = (v-u)/T
	velocity.y = u
	$PhysicsTimer.start()
	
func _process(delta: float) -> void:
	velocity.y += a*delta
	move_and_slide()


func _on_physics_timer_timeout() -> void:
	a/=4 # decrease "perceived" acceleration
