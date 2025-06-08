extends Node

@onready var intro_scene = preload("res://scenes/intro/intro.tscn")
@onready var game_scene = preload("res://scenes/main/main.tscn")

var intro_music = preload("res://assets/music/intro.mp3")
var game_music = preload("res://assets/music/game.mp3")
@onready var music_node = %Music
@onready var current_scene_node = %CurrentScene

func _ready() -> void:
	current_scene_node.add_child(intro_scene.instantiate())
	
	music_node.stream = intro_music
	music_node.play()

func _process(_delta: float) -> void:
	pass
