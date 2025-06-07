extends Node2D

@onready var projectiles_node = %Projectiles
@onready var player_node = %Player

func _ready() -> void:
	player_node.projectiles_node = projectiles_node
	$Stage.layer = -1

func _process(delta: float) -> void:
	pass
