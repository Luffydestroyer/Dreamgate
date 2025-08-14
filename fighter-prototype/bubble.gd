extends Node2D
class_name Bubble

signal option_selected(value)

# Node references
var main: AnimatedSprite2D
var mid: AnimatedSprite2D
var bottom: AnimatedSprite2D
var option_icon: Sprite2D
var collision_shape: CollisionShape2D

# Configuration
const MID_OFFSET := Vector2(-15, 8)
const BOTTOM_OFFSET := Vector2(-18, 14)
const ANIM_DURATION := 0.3
const FLOAT_AMPLITUDE := 1.5
const FLOAT_SPEED := 2.0

# State
var option_value: Variant
var start_pos: Vector2
var end_pos: Vector2
var icon_texture: Texture2D
var is_visible := false
var float_timer := 0.0
var is_ready := false

func _ready():
	# Get references to nodes
	main = $Main
	mid = $Mid
	bottom = $Bottom
	option_icon = $Main/OptionIcon
	collision_shape = $Main/Area2D/CollisionShape2D
	
	# Apply initialization if we have data
	if start_pos != Vector2.ZERO and end_pos != Vector2.ZERO:
		update_positions()
	if icon_texture:
		option_icon.texture = icon_texture
	
	# Set initial state
	scale = Vector2(0.1, 0.1)
	modulate.a = 0
	collision_shape.disabled = true
	
	is_ready = true

func initialize(p_start_pos: Vector2, p_end_pos: Vector2, p_icon_texture: Texture2D, value: Variant):
	print("Initializing bubble at: ", p_start_pos, " to ", p_end_pos)
	start_pos = p_start_pos
	end_pos = p_end_pos
	icon_texture = p_icon_texture
	option_value = value
	
	# If already in the scene tree, set up immediately
	if is_inside_tree():
		update_positions()
		if option_icon:
			option_icon.texture = icon_texture

func update_positions():
	# Calculate midpoint
	var mid_point = (start_pos + end_pos) / 2
	
	# Position bubbles with offsets
	bottom.position = start_pos + BOTTOM_OFFSET
	mid.position = mid_point + MID_OFFSET
	main.position = end_pos

func set_start_position(new_pos: Vector2):
	start_pos = new_pos
	if is_ready:
		update_positions()

func set_end_position(new_pos: Vector2):
	end_pos = new_pos
	if is_ready:
		update_positions()

func show_bubble():
	if is_visible or !is_ready: 
		return
	is_visible = true
	
	# Animation sequence: bottom -> mid -> main
	var tween = create_tween().set_parallel(false)
	
	# Bottom bubble
	tween.tween_property(bottom, "scale", Vector2(1, 1), ANIM_DURATION * 0.3)\
		.from(Vector2(0.1, 0.1))\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Mid bubble
	tween.tween_property(mid, "scale", Vector2(1, 1), ANIM_DURATION * 0.4)\
		.from(Vector2(0.1, 0.1))\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Main bubble with icon
	tween.tween_property(main, "scale", Vector2(1, 1), ANIM_DURATION * 0.5)\
		.from(Vector2(0.1, 0.1))\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Fade in all elements
	tween.parallel().tween_property(self, "modulate:a", 1.0, ANIM_DURATION)
	
	# Enable interaction when animation completes
	tween.tween_callback(func(): 
		if is_visible: # Only enable if still visible
			collision_shape.disabled = false
	)

func hide_bubble():
	if !is_visible or !is_ready: 
		return
	is_visible = false
	collision_shape.disabled = true
	
	var tween = create_tween().set_parallel(true)
	
	# Scale down all bubbles
	tween.tween_property(main, "scale", Vector2(0.1, 0.1), ANIM_DURATION * 0.5)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(mid, "scale", Vector2(0.1, 0.1), ANIM_DURATION * 0.4)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	
	tween.tween_property(bottom, "scale", Vector2(0.1, 0.1), ANIM_DURATION * 0.3)\
		.set_ease(Tween.EASE_IN)\
		.set_trans(Tween.TRANS_BACK)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, ANIM_DURATION)

func _process(delta):
	if !is_visible or !is_ready: 
		return
	
	# Update floating animation
	float_timer += delta * FLOAT_SPEED
	bottom.position.y = start_pos.y + BOTTOM_OFFSET.y + sin(float_timer) * FLOAT_AMPLITUDE
	mid.position.y = ((start_pos.y + end_pos.y) / 2) + MID_OFFSET.y + cos(float_timer * 0.8) * FLOAT_AMPLITUDE

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		option_selected.emit(option_value)
		# Add a little "pulse" effect when clicked
		var tween = create_tween()
		tween.tween_property(main, "scale", Vector2(1.1, 1.1), 0.1)
		tween.tween_property(main, "scale", Vector2(1, 1), 0.1)
