extends VBoxContainer
class_name StyleOptions

signal style_selected(style_resource)

@export var execution_styles: Array[Resource] = []

func _ready():
	create_style_list()

func create_style_list():
	for style in execution_styles:
		var button = Button.new()
		button.text = style.name + " (" + ("+" if style.bp_cost > 0 else "") + str(style.bp_cost) + " BP)"
		button.custom_minimum_size = Vector2(200, 40)
		button.pressed.connect(_on_style_selected.bind(style))
		add_child(button)

func _on_style_selected(style):
	emit_signal("style_selected", style)
