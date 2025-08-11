extends Node


func _ready():
	SignalBus.fighting_time.connect(_on_fighting_time)



func _on_fighting_time():
	var fighting_world: PackedScene = load("res://scenes/battle_scene.tscn")
	var enter_fight = fighting_world.instantiate()
	get_parent().add_child(enter_fight)
	queue_free()
