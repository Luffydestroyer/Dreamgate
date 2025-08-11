extends CharacterBody2D

var hp
var max_hp
var bp
var bp_max
var speed
var momentum
var weight
var hitbox
var airborne: bool


@onready var anim = $AnimatedSprite2D

@export var fighter: String = "Ren"


func _ready():
	anim.play("idle")


func _process(delta):
	if not is_on_floor():
		velocity += get_gravity() * (delta)
		airborne = true
	else:
		airborne = false
	
	
	if Input.is_action_just_pressed("punch_anim_test"):
		anim.play("punch_basic")
	if Input.is_action_just_pressed("punch_heavy_anim_test"):
		anim.play("punch_heavy")
	if Input.is_action_just_pressed("kick_anim_test"):
		anim.play("kick")
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
	
	move_and_slide()



func _set_player():
	pass


func _on_animated_sprite_2d_animation_finished():
	if anim.animation != "idle":
			anim.play("idle")
			print("uhj")
