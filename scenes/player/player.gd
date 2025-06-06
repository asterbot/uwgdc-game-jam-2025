extends Node2D

@onready var projectile_scene = preload("res://scenes/projectile/projectile.tscn")  

var can_shoot: bool = true

# we assign this in the main function
var projectiles_node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var mouse_pos: Vector2 = get_local_mouse_position()
	var cannon_pos: Vector2 = $Cannon.position
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	# positions will be bounded within the screen
	$Cursor.position = Vector2(
		clamp(mouse_pos.x, 0, viewport_size.x),
		clamp(mouse_pos.y, 0, viewport_size.y)
	)
	# cannon follows the cursor, always at bottom of screen
	$Cannon.position = Vector2(
		# x-coord uses frame-agnositc lerp smoothing, source: https://youtu.be/LSNQuFEDOyQ?t=2921
		mouse_pos.x + (cannon_pos.x - mouse_pos.x)*exp(-5*delta),
		viewport_size.y
	)


func _input(event: InputEvent):
	if event is InputEventMouseButton and Input.is_action_just_pressed("shoot"):
		if can_shoot:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.start_pos = $Cannon.position
			new_projectile.mouse_pos = event.position
			projectiles_node.add_child(new_projectile)
			can_shoot = false
			$CooldownTimer.start()


func _on_cooldown_timer_timeout() -> void:
	can_shoot=true
