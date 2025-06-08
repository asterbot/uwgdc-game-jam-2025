extends Node

@onready var intro_scene = preload("res://scenes/intro/intro.tscn")
@onready var game_scene = preload("res://scenes/main/main.tscn")

var intro_music = preload("res://assets/music/intro.mp3")
var game_music = preload("res://assets/music/game.mp3")
@onready var music_node = %Music
@onready var current_scene_node = %CurrentScene

var intro_finished: bool = false

func _ready() -> void:
	# intro stuff
	current_scene_node.add_child(intro_scene.instantiate())
	music_node.stream = intro_music
	music_node.play()


func _process(_delta: float) -> void:
	%TransitionLayer.modulate.a = Globals.transition_alpha


func _on_current_scene_child_exiting_tree(node: Node) -> void:
	intro_finished = true
	current_scene_node.add_child.call_deferred(game_scene.instantiate())
	var tween = create_tween()
	tween.tween_property(Globals, "transition_alpha", 0.0, 0.5)
	await tween.finished
	music_node.stream = game_music
	music_node.play()


func _on_music_finished() -> void:
	if intro_finished:
		music_node.play()
