extends Resource
class_name ModifierResource

@export var name: String = "Fire"
@export var bp_cost: int = 3
@export var icon: Texture2D
@export var description: String = "Adds fire element"
@export var incompatible_with: Array[String] = ["water", "ice"]