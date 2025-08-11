extends CharacterBody2D

var speed := 300
var moving := true

@onready var hitbox = $CollisionShape2D

@onready var animation = $AnimatedSprite2D


func _ready():
	animation.play("idle")

func _process(delta):
	if moving:
		velocity = Vector2.ZERO
		
		# Input movement
		if Input.is_action_pressed("down"):
			velocity.y += 1
		elif Input.is_action_pressed("up"):
			velocity.y -= 1
		
		if Input.is_action_pressed("right"):
			velocity.x += 1
		elif Input.is_action_pressed("left"):
			velocity.x -= 1
		
		# Normalize to prevent diagonal speed boost
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			_play_walk_animation()
		else:
			_play_idle_animation()
		
		# Smooth movement
		move_and_slide()

func _play_walk_animation():
	if velocity.y > 0:
		animation.play("walk_down")
	elif velocity.y < 0:
		animation.play("walk_up")
	elif velocity.x > 0:
		animation.play("walk_right")
	elif velocity.x < 0:
		animation.play("walk_left")

func _play_idle_animation():
	animation.play("idle")


func _on_overworld_enemy_body_entered(body):
	SignalBus.fighting_time.emit()

func _do_transition():
	hitbox.disabled = true
	SignalBus.new_room.emit()
	hitbox.disabled = false

func _on_room_transition_body_entered(body):
	_do_transition.call_deferred()
