extends CanvasLayer

var score_increment_label = preload("res://scenes/score/score_increment.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	%Score.text = str(Globals.score)

func increment_score(points: float):
	Globals.score += points
	var new_score_increment_label = score_increment_label.instantiate()
	new_score_increment_label.text = "+ " + str(points)
	%Scores.add_child(new_score_increment_label)
