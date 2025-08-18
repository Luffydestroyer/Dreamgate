extends Combatant

@onready var build_wheel = $BuildWheel

func _ready():
	super._ready()
	# Connect to UI signals
	var ui = get_tree().root.find_child("BattleUI", true, false)
	if ui:
		ui.action_selected.connect(_on_ui_action_selected)
	
	# Connect build wheel
	if build_wheel:
		build_wheel.custom_action_created.connect(_on_custom_action_created)

func _on_ui_action_selected(action_type, action_data):
	if action_type == "construct":
		build_wheel.open()
	else:
		get_parent().add_player_action(action_type, action_data)

func _on_custom_action_created(custom_action):
	get_parent().add_player_action("construct", custom_action)

# Implement animation player
func play_animation(anim_name: String):
	if $AnimationPlayer.has_animation(anim_name):
		$AnimationPlayer.play(anim_name)
