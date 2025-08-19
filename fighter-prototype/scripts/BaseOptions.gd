extends Control
class_name BaseOptions

signal base_selected(base_resource)

@export var base_forms: Array[Resource] = []

func _ready():
	create_radial_menu()

func create_radial_menu():
	var center = Vector2(size.x / 2, size.y / 2)
	var radius = min(size.x, size.y) * 0.4
	var angle_step = TAU / base_forms.size()
	
	for i in range(base_forms.size()):
		var base_form = base_forms[i]
		var button = TextureButton.new()
		button.texture_normal = base_form.icon
		button.custom_minimum_size = Vector2(64, 64)

		var angle = angle_step * i
		var position = center + Vector2(cos(angle), sin(angle)) * radius
		button.position = position - Vector2(32, 32)

		button.pressed.connect(_on_base_selected.bind(base_form))
		add_child(button)

func _on_base_selected(base_form):
	emit_signal("base_selected", base_form)
