extends CanvasLayer


var bubble_scene = preload("res://scenes/bubble.tscn")


func _ready():
	# Create bubbles when needed
	create_action_bubble("fight", preload("res://assets/sprites/ui/placeholdertext.png"))

func create_action_bubble(action_type: String, icon_texture: Texture2D):
	var bubble:Bubble = bubble_scene.instantiate()
	# Position relative to player
	var player_pos = Vector2(-50, 40) if PPH else Vector2.ZERO
	
	# Set positions - adjust these values as needed
	#var start_pos = player_pos + Vector2(0, -50)  # Above player
	#var end_pos = player_pos + Vector2(100, -100)  # Offset for main bubble
	var start_pos = Vector2(200, 20)
	var end_pos = Vector2(30,30)
	bubble.initialize(start_pos, end_pos, icon_texture, action_type)
	add_child(bubble)
	bubble.show_bubble()
	
	# Connect signal
	bubble.option_selected.connect(_on_bubble_selected)

func _on_bubble_selected(value):
	print("Selected option: ", value)
