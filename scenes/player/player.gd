extends Node2D

@onready var projectile_scene = preload("res://scenes/projectile/projectile.tscn")  
@onready var cursor_sprite: Sprite2D = $Cursor
@onready var cannon_sprite: Sprite2D = $Cannon

var mouse_pos: Vector2
var cannon_pos: Vector2
var viewport_size: Vector2

var can_shoot: bool = true

# we assign this in the main function
var projectiles_node

func _ready() -> void:
	self.z_index = Globals.NUM_Z_INDICES*10; # draw on top of EVERYTHING

func _process(delta: float) -> void:
	mouse_pos = get_local_mouse_position()
	cannon_pos = cannon_sprite.position
	viewport_size = get_viewport().get_visible_rect().size
	
	# positions will be bounded within the screen
	cursor_sprite.position = Vector2(
		clamp(mouse_pos.x, 0, viewport_size.x),
		clamp(mouse_pos.y, 0, viewport_size.y)
	)
	var cursor_sprite_scale: float = 0.5 + 1.5*(mouse_pos.y/viewport_size.y)
	cursor_sprite.scale = Vector2(cursor_sprite_scale, cursor_sprite_scale)
	# cannon follows the cursor, always at bottom of screen
	cannon_sprite.position = Vector2(
		# x-coord uses frame-agnositc lerp smoothing, source: https://youtu.be/LSNQuFEDOyQ?t=2921
		mouse_pos.x + (cannon_pos.x - mouse_pos.x)*exp(-5*delta),
		viewport_size.y
	)
	
	# Set cannon to point at cursor
	var diff_vector : Vector2 = (cursor_sprite.global_position - cannon_sprite.global_position).normalized()
	cannon_sprite.rotation = diff_vector.angle() + PI/2

	if Input.is_action_pressed("shoot") and can_shoot:
			var new_projectile = projectile_scene.instantiate()
			new_projectile.start_pos = %ProjectileSpawnPos.global_position
			new_projectile.mouse_pos = mouse_pos
			new_projectile.target_depth = mouse_pos.y/viewport_size.y
			projectiles_node.add_child(new_projectile)
			can_shoot = false
			$CooldownTimer.start()


func _on_cooldown_timer_timeout() -> void:
	can_shoot=true
