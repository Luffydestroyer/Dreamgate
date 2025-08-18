extends CanvasLayer


var bubble_scene = preload("res://scenes/bubble.tscn")
var done:bool = false

@onready var action_menu = $ActionMenu
@onready var health_bar: TextureProgressBar = $HealthBar
@onready var bp_bar: TextureProgressBar = $BPBar
@onready var momentum_bar: TextureProgressBar = $MomentumBar

func init_ui(player):
	health_bar.set_value_no_signal(player.max_hp)
	bp_bar.set_value_no_signal(player.max_bp)
	momentum_bar

func _process(delta):
	# Create bubbles when needed
	if !PPH.airborne and !done:
		create_action_bubble("fight", preload("res://assets/sprites/ui/Fight_Text.png"))
		done = true

func create_action_bubble(action_type: String, icon_texture: Texture2D):
	var bubble:Bubble = bubble_scene.instantiate()
	# Position relative to player
	var player_pos = Vector2(PPH.x, PPH.y) if PPH else Vector2.ZERO
	print_debug(PPH.x, PPH.y)
	# Set positions - adjust these values as needed
	var start_pos = Vector2(490, 370) 
	var end_pos = Vector2(497, 365)  
	
	bubble.initialize(start_pos, end_pos, icon_texture, action_type)
	add_child(bubble)
	bubble.show_bubble()
	
	# Connect signal
	bubble.option_selected.connect(_on_bubble_selected)

func _on_bubble_selected(value):
	print("Selected option: ", value)

func show_action_menu():
	action_menu.show_menu()

func update_bars(player):
	health_bar.update(player.hp)
	bp_bar.update(player.bp)
	momentum_bar.update(player.momentum)

func _on_action_selected(action_type, action_data):
	get_parent().add_player_action(action_type, action_data)

func _on_construct_pressed():
	get_parent().build_wheel.open()
