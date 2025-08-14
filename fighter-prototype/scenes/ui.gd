extends CanvasLayer


var bubble_scene = preload("res://scenes/bubble.tscn")
var done:bool = false

func _process(delta):
	# Create bubbles when needed
	if !PPH.airborne and !done:
		create_action_bubble("fight", preload("res://assets/sprites/ui/placeholdertext.png"))
		done = true

func create_action_bubble(action_type: String, icon_texture: Texture2D):
	var bubble:Bubble = bubble_scene.instantiate()
	# Position relative to player
	var player_pos = Vector2(PPH.x, PPH.y) if PPH else Vector2.ZERO
	print_debug(PPH.x, PPH.y)
	# Set positions - adjust these values as needed
	var start_pos = Vector2(500, 400) 
	var end_pos = Vector2(500, 500)  
	
	bubble.initialize(start_pos, end_pos, icon_texture, action_type)
	add_child(bubble)
	bubble.show_bubble()
	
	# Connect signal
	bubble.option_selected.connect(_on_bubble_selected)

func _on_bubble_selected(value):
	print("Selected option: ", value)
