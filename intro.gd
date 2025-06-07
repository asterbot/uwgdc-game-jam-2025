extends CanvasLayer

@onready var cutscene_scene = preload("res://scenes/cutscene.tscn")

@onready var cutscene_images = [
	preload("res://assets/cutscenes/cutscene_1.png"),
	preload("res://assets/cutscenes/cutscene_2.png"),
	preload("res://assets/cutscenes/cutscene_3.png"),
]

var cutscene_texts = [
	"Yeehaw! You've got a FRIEND inside me!",
	"I dare you to smell my butwhole",
	"HAHAHAHAHA I just PRANKED you",
]

var num_cutscenes: int
var cutscene_index: int = 0
var curr_cutscene: CanvasLayer

func _ready() -> void:
	assert (len(cutscene_images) == len(cutscene_texts), "ERROR: different amounts of cutscene images and texts")
	num_cutscenes = len(cutscene_images)
	
	create_cutscene()
	var tween = modulate_cutscene(1.0)
	await tween.finished
	
	$CutsceneSwapTimer.start()


func _process(_delta: float) -> void:
	pass


func create_cutscene() -> void:
	curr_cutscene = cutscene_scene.instantiate()
	add_child(curr_cutscene)
	curr_cutscene.set_image(cutscene_images[cutscene_index])
	curr_cutscene.set_text(cutscene_texts[cutscene_index])
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
	cutscene_index += 1
	# only go to next cutscene if it exists
	if cutscene_index < num_cutscenes:
		create_cutscene()
		tween = modulate_cutscene(1.0)
		await tween.finished
		$CutsceneSwapTimer.start()
	else:
		# transition to gameplay scene?
		pass
