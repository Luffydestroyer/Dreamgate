extends Node2D

@onready var icon_2 = $Icon2
var deltatime = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deltatime += delta
	icon_2.position.x = sin(deltatime * 0.2) * 100
	print(icon_2.position.x)
