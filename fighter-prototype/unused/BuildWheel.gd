extends Control

signal custom_action_created(custom_action)

enum STAGE { BASE, MODIFIER, EXECUTION }

var current_stage = STAGE.BASE
var current_base = null
var current_modifiers = []
var current_style = null
var bp_cost = 0

@onready var base_options = $BaseOptions
@onready var modifier_options = $ModifierOptions
@onready var style_options = $StyleOptions
@onready var cost_label = $CostLabel

func open():
	show()
	reset()
	show_stage(STAGE.BASE)

func reset():
	current_base = null
	current_modifiers.clear()
	current_style = null
	bp_cost = 0

func show_stage(stage):
	current_stage = stage
	base_options.visible = (stage == STAGE.BASE)
	modifier_options.visible = (stage == STAGE.MODIFIER)
	style_options.visible = (stage == STAGE.EXECUTION)
	update_cost_display()

func _on_base_selected(base_resource):
	current_base = base_resource
	bp_cost = base_resource.bp_cost
	show_stage(STAGE.MODIFIER)

func _on_modifier_selected(modifier_resource):
	if current_modifiers.size() < get_modifier_slots():
		current_modifiers.append(modifier_resource)
		bp_cost += modifier_resource.bp_cost
	update_cost_display()

func _on_style_selected(style_resource):
	current_style = style_resource
	bp_cost += style_resource.bp_cost
	create_custom_action()

func create_custom_action():
	var custom_action = {
		"name": generate_action_name(),
		"bp_cost": bp_cost,
		"frame_cost": calculate_frame_cost(),
		"base": current_base,
		"modifiers": current_modifiers.duplicate(),
		"style": current_style
	}
	emit_signal("custom_action_created", custom_action)
	hide()

func generate_action_name() -> String:
	var name = ""
	if current_style: name += current_style.prefix + " "
	for modifier in current_modifiers: name += modifier.name + " "
	if current_base: name += current_base.name
	return name

func calculate_frame_cost() -> int:
	var cost = current_base.base_frame_cost
	if current_style: cost += current_style.frame_cost_mod
	return cost

func get_modifier_slots() -> int:
	# Increase with level
	return 1

func update_cost_display():
	cost_label.text = "BP Cost: %d" % bp_cost
