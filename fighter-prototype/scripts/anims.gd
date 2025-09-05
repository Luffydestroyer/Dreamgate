extends Node2D

# Class to hold frame data
class FrameData:
	var frame: Rect2
	var duration: float
	var filename: String

# Class to hold animation data
class AnimationData:
	var name: String
	var frames: Array
	var from: int
	var to: int

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var texture: Texture2D
var json_data: Dictionary
var animations: Array = []
signal animation_finished(anim_name)

func _ready():
	# Configure the sprite
	if texture:
		sprite.texture = texture
		sprite.region_enabled = true
	
	# Load JSON data
	var json_file = FileAccess.open("res://assets/sprites/battle_sprites/placeholder_fighter/Anims.json", FileAccess.READ)
	if json_file:
		var json_text = json_file.get_as_text()
		json_data = JSON.parse_string(json_text)
		json_file.close()
	else:
		push_error("Failed to open JSON file!")
		return
	
	if json_data.is_empty():
		push_error("JSON data is empty!")
		return
	
	# Parse the JSON data
	parse_json_data()
	
	# Create animations
	create_animations()
	
	animation_player.connect("animation_finished", _on_animation_finished)
	
	# Play the first animation if available
	if animations.size() > 0:
		play_animation(animations[0].name)

func _on_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)

# Parse the JSON data into usable structures
func parse_json_data():
	# Extract frames
	var frames_data = json_data.get("frames", [])
	var frame_tags = json_data.get("meta", {}).get("frameTags", [])
	
	# Create FrameData objects for each frame
	var all_frames = []
	for frame_dict in frames_data:
		var frame = frame_dict.get("frame", {})
		var frame_rect = Rect2(frame.get("x", 0), frame.get("y", 0), 
							frame.get("w", 0), frame.get("h", 0))
		
		var frame_data = FrameData.new()
		frame_data.frame = frame_rect
		frame_data.duration = frame_dict.get("duration", 100) / 1000.0  # Convert to seconds
		frame_data.filename = frame_dict.get("filename", "")
		
		all_frames.append(frame_data)
	
	# Create AnimationData objects for each animation
	for tag in frame_tags:
		var anim_data = AnimationData.new()
		anim_data.name = tag.get("name", "")
		anim_data.from = tag.get("from", 0)
		anim_data.to = tag.get("to", 0)
		anim_data.frames = []
		
		# Add frames for this animation
		for i in range(anim_data.from, anim_data.to + 1):
			if i < all_frames.size():
				anim_data.frames.append(all_frames[i])
		
		animations.append(anim_data)

# Create animations in the AnimationPlayer using AnimationLibrary
func create_animations():
	var library = AnimationLibrary.new()
	
	for anim_data in animations:
		var animation = Animation.new()
		var track_index = animation.add_track(Animation.TYPE_VALUE)
		
		# Set up the track to control the sprite's region
		animation.track_set_path(track_index, "Sprite2D:region_rect")
		animation.track_set_interpolation_type(track_index, Animation.INTERPOLATION_NEAREST)
		
		var time = 0.0
		for frame_data in anim_data.frames:
			# Add key for this frame
			animation.track_insert_key(track_index, time, frame_data.frame)
			time += frame_data.duration
		
		# Set animation length
		animation.length = time
		
		# Add animation to library
		library.add_animation(anim_data.name, animation)
		print("Added animation: ", anim_data.name)
	
	# Add the library to the animation player
	animation_player.add_animation_library("", library)
	print("Number of animations: ", animations.size())

# Play a specific animation by name
func play_animation(anim_name: String):
	if animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
		print("Playing animation: ", anim_name)
	else:
		push_error("Animation not found: " + anim_name)

# Called every frame
func _process(_delta):
	pass
