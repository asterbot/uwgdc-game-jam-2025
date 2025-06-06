extends Node2D

@onready var projectile_scene = preload("res://scenes/projectile/projectile.tscn")  

var can_shoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Cursor.position = get_viewport().get_mouse_position()
	

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if can_shoot:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.mouse_position = event.position
			$Projectiles.add_child(new_projectile)
			can_shoot=false
			$CoolDownTimer.start()
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)

	# Print the size of the viewport.
	# print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)


func _on_cool_down_timer_timeout() -> void:
	can_shoot=true
	pass # Replace with function body.
