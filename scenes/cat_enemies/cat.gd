class_name Enemy

extends CharacterBody2D

var projectiles_in_range = []

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	for projectile in projectiles_in_range:
		if projectile.scale.x < 0.5:
			print("Damage! OUCHIE! SPLAT")
			projectile.queue_free()


func _on_area_2d_area_entered(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.append(projectile)


func _on_area_2d_area_exited(projectile_area: Area2D) -> void:
	var projectile = projectile_area.get_parent()
	projectiles_in_range.erase(projectile)
