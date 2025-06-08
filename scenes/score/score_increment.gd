extends Label

func _ready():
	$DespawnTimer.start()

func _process(_delta: float) -> void:
	pass

func _on_despawn_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	await tween.finished
	queue_free()
