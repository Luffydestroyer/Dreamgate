extends Node2D
class_name Bubble

signal option_selected(value)

# Node references
@onready var main: AnimatedSprite2D = $Main
@onready var mid: AnimatedSprite2D = $Mid
@onready var bottom: AnimatedSprite2D = $Bottom
@onready var option_icon: Sprite2D = $Main/OptionIcon
@onready var collision_shape: CollisionShape2D = $Main/Area2D/CollisionShape2D

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

func initialize(p_start_pos: Vector2, p_end_pos: Vector2, p_icon_texture: Texture2D, value: Variant):
	start_pos = p_start_pos
	end_pos = p_end_pos
	icon_texture = p_icon_texture
	option_value = value
	
	# Ensure nodes are ready before accessing them
	if not is_inside_tree():
		await ready
	
	option_icon.texture = icon_texture
	update_positions()
	
	# Set initial state for animation
	main.scale = Vector2(0.1, 0.1)
	mid.scale = Vector2(0.1, 0.1)
	bottom.scale = Vector2(0.1, 0.1)
	modulate.a = 0
	collision_shape.disabled = true

func update_positions():
	# Calculate midpoint
	var mid_point = (start_pos + end_pos) / 2
	
	# Position bubbles with offsets
	bottom.position = start_pos + BOTTOM_OFFSET
	mid.position = mid_point + MID_OFFSET
	main.position = end_pos

func show_bubble():
	if is_visible: 
		return
		
	is_visible = true
	
	# Ensure nodes are ready
	if not main or not mid or not bottom:
		return
	
	# Reset scales
	main.scale = Vector2(0.1, 0.1)
	mid.scale = Vector2(0.1, 0.1)
	bottom.scale = Vector2(0.1, 0.1)
	
	# Animation sequence: bottom -> mid -> main
	var tween = create_tween().set_parallel(false)
	
	# Bottom bubble
	tween.tween_property(bottom, "scale", Vector2(2, 2), ANIM_DURATION * 0.3)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Mid bubble
	tween.tween_property(mid, "scale", Vector2(2, 2), ANIM_DURATION * 0.4)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_BACK)
	
	# Main bubble with icon
	tween.tween_property(main, "scale", Vector2(2, 2), ANIM_DURATION * 0.5)\
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
	if !is_visible: 
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
	if !is_visible: 
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
