extends CanvasLayer

@onready var cutscene_image_node: TextureRect = %CutsceneImage
@onready var cutscene_text_node: RichTextLabel = %CutsceneText


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var viewport_size = get_viewport().get_visible_rect()
	var textbox_area = viewport_size.get_area()/3
	cutscene_text_node.add_theme_font_size_override(
		"normal_font_size", textbox_area/10000
	)

func set_image(img_packed_scene: Texture2D) -> void:
	cutscene_image_node.texture = img_packed_scene

func set_text(text: String) -> void:
	cutscene_text_node.text = "[center]" + text
