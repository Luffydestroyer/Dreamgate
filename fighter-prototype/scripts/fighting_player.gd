extends CharacterBody2D

var hp
var max_hp
var bp
var bp_max
var speed
var momentum
var weight
var hitbox

@onready var anim = $AnimatedSprite2D

@export var fighter: String = "Ren"


func _ready():
	anim.play("idle")

func _process(delta):
	pass

func _set_player():
	pass
