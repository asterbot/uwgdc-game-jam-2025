extends CanvasLayer

var score_increment_label = preload("res://scenes/score/score_increment.tscn")

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	%Score.text = str(Globals.score)
	%WaveLabel.text = "Wave " + str(Globals.cur_wave)

func increment_score(points: float):
	Globals.score += points
	var new_score_increment_label = score_increment_label.instantiate()
	new_score_increment_label.text = "+ " + str(points)
	for i in range(int(floor(points-100)/100)):
		new_score_increment_label.text += "!"
	new_score_increment_label.label_settings.font_size = 25 + 0.1*(points)
	%Scores.add_child(new_score_increment_label)
