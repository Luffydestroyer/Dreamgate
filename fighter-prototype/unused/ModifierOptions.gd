extends GridContainer
class_name ModifierOptions

signal modifier_selected(modifier_resource)

@export var modifiers: Array[Resource] = []

func _ready():
	columns = min(columns, modifiers.size())
	create_modifier_grid()

func create_modifier_grid():
	for modifier in modifiers:
		var button = Button.new()
		button.text = modifier.name
		button.custom_minimum_size = Vector2(100, 40)
		button.tooltip_text = modifier.description + "\nCost: +" + str(modifier.bp_cost) + " BP"
		button.pressed.connect(_on_modifier_selected.bind(modifier))
		add_child(button)

func _on_modifier_selected(modifier):
	emit_signal("modifier_selected", modifier)
