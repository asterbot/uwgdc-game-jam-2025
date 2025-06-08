extends CanvasLayer

@onready var cutscene_scene = preload("res://scenes/cutscene/cutscene.tscn")

@onready var cutscene_data = {
	0: {
		"text": "Alright, so here's the deal...",
		"timer": 3
	},
	1: {
		"image": preload("res://assets/cutscenes/cutscene_1.png"),
		"text": "These past few weeks have witnessed the dire SCE (Stinky Cat Epidemic) event.",
		"timer": 5
	},
	2: {
		"image": preload("res://assets/cutscenes/cutscene_2.png"),
		"text": "The citizens are being tormented by these cats, and it's been worsening by the day. So that's where it comes to you.",
		"timer": 6
	},
	3: {
		"image": preload("res://assets/cutscenes/cutscene_3.png"),
		"text": "Hey, don't look at me! Our forces has been wiped out and you're the last line of defence!",
		"timer": 6
	},
	4: {
		"image": preload("res://assets/cutscenes/cutscene_4.png"),
		"text": "Ahem. Anyways, we've developed a special type of cat deodorant and we'd like you to freshen up the city.",
		"timer": 6
	},
	5: {
		"image": preload("res://assets/cutscenes/cutscene_5.png"),
		"text": "Go smack them with your deodorant cannon! The city depends on it!",
		"timer": 4
	},
}

var curr_cutscene: CanvasLayer
var curr_cutscene_index: int = 0

func _ready() -> void:
	create_cutscene(curr_cutscene_index)
	var tween = modulate_cutscene(1.0)
	await tween.finished
	set_up_timer(curr_cutscene_index)


func _process(_delta: float) -> void:
	pass


func set_up_timer(curr_cutscene_index):
	$CutsceneSwapTimer.wait_time = cutscene_data[curr_cutscene_index]["timer"]
	$CutsceneSwapTimer.start()


func create_cutscene(curr_cutscene_index) -> void:
	curr_cutscene = cutscene_scene.instantiate()
	add_child(curr_cutscene)
	var curr_cutscene_data: Dictionary = cutscene_data[curr_cutscene_index]
	if curr_cutscene_data.has("image"):
		curr_cutscene.set_image(cutscene_data[curr_cutscene_index]["image"])
	else:
		curr_cutscene.set_image(null)
	if curr_cutscene_data.has("text"):
		curr_cutscene.set_text(cutscene_data[curr_cutscene_index]["text"])
	else:
		curr_cutscene.set_text("")
	curr_cutscene.cutscene_image_node.modulate.a = 0.0
	curr_cutscene.cutscene_text_node.modulate.a = 0.0


func modulate_cutscene(to: float, modulate_time: float = 0.5) -> Tween:
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(curr_cutscene.cutscene_image_node, "modulate:a", to, modulate_time)
	tween.tween_property(curr_cutscene.cutscene_text_node, "modulate:a", to, modulate_time)
	return tween

func _on_cutscene_swap_timer_timeout() -> void:
	var tween: Tween
	tween = modulate_cutscene(0.0)
	await tween.finished
	curr_cutscene_index += 1
	# only go to next cutscene if it exists
	if curr_cutscene_index < cutscene_data.size():
		create_cutscene(curr_cutscene_index)
		tween = modulate_cutscene(1.0)
		await tween.finished
		set_up_timer(curr_cutscene_index)
	else:
		# transition to gameplay scene?
		pass
