extends Node
class_name BattleManager

enum BATTLE_STATE { CHOOSE_ACTION, RESOLVING, END }

signal battle_ended(result)
signal turn_started
signal action_resolved

@export var player_scene: PackedScene = preload("res://scenes/fighting_player.tscn")
@export var enemy_scene: PackedScene

var current_state = BATTLE_STATE.CHOOSE_ACTION
var action_queue = []
var combatants = []
var player
var enemies = []
var current_turn = 0

@onready var ui = self.get_parent().get_node("BattleUI")
@onready var build_wheel = $Player/BuildWheel

func _ready():
	init_battle()
	
func init_battle():
	# Spawn player and enemies
	player = player_scene.instantiate()
	add_child(player)
	combatants.append(player)
	
	#for i in range(3):
	#	var enemy = enemy_scene.instantiate()
	#	add_child(enemy)
	#	enemies.append(enemy)
	#	combatants.append(enemy)
	
	ui.init_ui(player)
	start_new_turn()

func start_new_turn():
	current_turn += 1
	emit_signal("turn_started", current_turn)
	current_state = BATTLE_STATE.CHOOSE_ACTION
	action_queue.clear()
	
	# Reset combatants
	for combatant in combatants:
		combatant.reset_for_new_turn()
	
	# Player chooses action via UI
	#ui.show_action_menu()
	
	# Enemies choose actions
	for enemy in enemies:
		enemy.choose_action()

func add_player_action(action_type, action_data = null):
	var action = {
		"combatant": player,
		"type": action_type,
		"data": action_data,
		"frame_cost": calculate_frame_cost(action_type, action_data)
	}
	action_queue.append(action)
	try_resolve_actions()

func add_enemy_action(enemy, action):
	action_queue.append({
		"combatant": enemy,
		"type": action.type,
		"data": action.data,
		"frame_cost": action.frame_cost
	})
	try_resolve_actions()

func try_resolve_actions():
	# Wait until all combatants have chosen actions
	if action_queue.size() == combatants.size():
		resolve_actions()

func resolve_actions():
	current_state = BATTLE_STATE.RESOLVING
	
	# Sort actions by frame cost (lowest first)
	action_queue.sort_custom(func(a, b): return a.frame_cost < b.frame_cost)
	
	for action in action_queue:
		if action.combatant.can_perform_action():
			var result = action.combatant.execute_action(action.type, action.data)
			emit_signal("action_resolved", action, result)
			
			# Check for interrupts
			if action.type != "guard" && action.frame_cost < 15:
				cancel_charging_actions()
	
	end_turn()

func cancel_charging_actions():
	for action in action_queue:
		if action.data && action.data.get("is_charging", false):
			action.combatant.cancel_action()
			emit_signal("action_resolved", action, "interrupted")

func calculate_frame_cost(action_type, action_data):
	match action_type:
		"fight":
			return action_data.frame_cost if action_data else 10
		"technique":
			return action_data.frame_cost if action_data else 20
		"construct":
			return action_data.frame_cost if action_data else 15
		"guard":
			return 5
		"move":
			return 8
		"item":
			return 12
	return 15

func end_turn():
	# Apply end-of-turn effects
	for combatant in combatants:
		combatant.process_end_of_turn()
	
	# Check battle end condition
	if player.is_defeated():
		emit_signal("battle_ended", "lose")
		return
	elif enemies.all(func(enemy): return enemy.is_defeated()):
		emit_signal("battle_ended", "win")
		return
	
	start_new_turn()

func _on_build_wheel_custom_action_created(custom_action):
	add_player_action("construct", custom_action)
