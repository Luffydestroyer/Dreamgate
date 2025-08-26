extends CharacterBody2D
class_name Combatant

signal action_executed(action_type, result)

@export var max_hp := 100
@export var max_bp := 50
@export var power := 10
@export var resilience := 5
@export var agility := 8
@export var evasiveness := 3

var hp: int
var bp: int
var momentum := 0.0
var in_burnout := false
var status_effects = {}
var current_action = null

var bp_max
var speed
var weight
var hitbox
var airborne: bool

var PPH = preload("res://scripts/playerposhandler.gd").new()

@onready var anim = $AnimatedSprite2D

@export var fighter: String = "Ren"

func _ready():
	hp = max_hp
	bp = max_bp

func choose_action():
	# To be implemented in derived classes
	pass

func execute_action(action_type, action_data):
	if in_burnout && action_type != "guard" && action_type != "item":
		return "burnout_blocked"

	var result = "success"
	match action_type:
		"fight":
			result = perform_attack(action_data)
		"technique":
			result = use_technique(action_data)
		"construct":
			result = use_custom_action(action_data)
		"guard":
			result = guard()
		"move":
			result = perform_movement(action_data)
		"item":
			result = use_item(action_data)
	emit_signal("action_executed", action_type, result)
	return result

func perform_attack(attack_data):
	if bp < attack_data.bp_cost:
		return "insufficient_bp"

	bp -= attack_data.bp_cost
	# Attack logic here
	return "attack_success"

func use_technique(technique_data):
	if bp < technique_data.bp_cost:
		return "insufficient_bp"
	
	bp -= technique_data.bp_cost
	# Technique logic here
	play_animation(technique_data.animation)
	return "technique_success"

func use_custom_action(custom_action):
	if bp < custom_action.bp_cost:
		return "insufficient_bp"
	
	bp -= custom_action.bp_cost
	# Execute custom action
	# This would handle different types: strike, blast, structure, etc.
	handle_custom_action(custom_action)
	return "custom_action_success"

func handle_custom_action(custom_action):
	match custom_action.base.type:
		"strike":
			perform_strike(custom_action)
		"blast":
			create_projectile(custom_action)
		"structure":
			create_structure(custom_action)
		"trap":
			place_trap(custom_action)
		"summon":
			summon_entity(custom_action)

func perform_strike(custom_action):
	# melee attack 
	pass

func create_projectile(custom_action):
	# prpjectiles
	pass

func create_structure(custom_action):
	# structures
	pass

func place_trap(custom_action):
	# trap
	pass

func summon_entity(custom_action):
	# entity
	pass

func guard():
	# guarding
	return "guard_success"

func perform_movement(move_data):
	if move_data && bp < move_data.get("bp_cost", 0):
		return "insufficient_bp"
	
	if move_data:
		bp -= move_data.get("bp_cost", 0)
	
	# Movement logic
	play_animation(move_data.animation if move_data else "dash")
	return "move_success"

func use_item(item_data):
	# Item usage logic
	play_animation("use_item")
	return "item_success"

func reset_for_new_turn():
	current_action = null

func process_end_of_turn():
	# Regen BP (faster when guarding or standing still)
	var regen_rate = 2
	if current_action == "guard" || current_action == null:
		regen_rate = 5

	bp = min(max_bp, bp + regen_rate)

	if bp >= max_bp * 0.3:
		in_burnout = false

	# Process status effects
	apply_status_effects()

func apply_status_effects():
	# Process poison, burn, etc.
	pass

func is_defeated() -> bool:
	return hp <= 0

func play_animation(anim_name: String):
	# tbd
	# $AnimationPlayer.play(anim_name)
	pass
	
func get_x():
	return self.position.x

func get_y():
	return self.position.y

func _on_animated_sprite_2d_animation_finished():
	if anim.animation != "idle":
			anim.play("idle")
			print("uhj")
