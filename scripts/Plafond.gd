extends Area2D



func _on_area_entered(area):
	area._die()
	area._jump_force *= 1.5
	area._nb_bumps += 1

