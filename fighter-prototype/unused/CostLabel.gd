extends Label
class_name CostLabel

func update_cost(cost: int):
	text = "BP Cost: %d" % cost
	modulate = Color.RED if cost > 20 else Color.WHITE
