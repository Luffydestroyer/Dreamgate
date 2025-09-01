extends CharacterBody2D

var hp
var max_hp
var bp
var bp_max
var speed: float = 2.5
var momentum
var weight
var hitbox
var airborne: bool

var PPH = preload("res://scripts/playerposhandler.gd").new()

@onready var anim = $Node2D #$AnimatedSprite2D
#@onready var offset = $AnimatedSprite2D/AnimationPlayer

@export var fighter: String = "Ren"


func _ready():
	anim.play_animation("Idle")
	PPH = get_node("/root/PPH")


func _process(delta):
	PPH.x = self.position.x
	PPH.y = self.position.y
	PPH.airborne = airborne
	if not is_on_floor():
		velocity += get_gravity() * (delta)
		airborne = true
	else:
		airborne = false
	
#	var os = anim.animation + "_offset"
#	var flipped = os + "_flipped"
#	if anim.flip_h and offset.has_animation(flipped):
#		offset.play(flipped)
#	elif offset.has_animation(os):
#		offset.play(os)

	
	if Input.is_action_just_pressed("punch_anim_test"):
		anim.play_animation("PunchLight")
	if Input.is_action_just_pressed("punch_heavy_anim_test"):
		anim.play_animation("PunchHeavy")
	if Input.is_action_just_pressed("kick_anim_test"):
		anim.play_animation("Kick")
	if Input.is_action_just_pressed("block_anim_test"):
		anim.play_animation("Block")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_pressed("left"):
		if anim.scale.x > 0:
			anim.apply_scale(Vector2(-1, 1))
		anim.play_animation("Run")
		self.position.x = self.position.x - speed
	if Input.is_action_pressed("right"):
		if anim.scale.x < 0:
			anim.apply_scale(Vector2(-1, 1))
		anim.play_animation("Run")
		self.position.x = self.position.x + speed
	if Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		anim.play_animation("Idle")
	if Input.is_action_just_pressed("up"):
		anim.play_animation("Jump")
	
	
	move_and_slide()



func _set_player():
	pass

func get_x():
	return self.position.x

func get_y():
	return self.position.y

func _on_animated_sprite_2d_animation_finished():
	if anim.animation != "Idle":
		anim.play_animation("Idle")
		#offset.play("RESET")
		print("uhj")
